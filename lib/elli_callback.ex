defmodule ElixirApiElli.ElliCallback do
  @behaviour :elli_handler

  alias RinhaBackend.Person

  def handle(req, _args) do
    do_handle(:elli_request.method(req), :elli_request.path(req), req)
  end

  defp do_handle(:GET, [], _req), do: {:ok, "Welcome!"}

  defp do_handle(:POST, ["pessoas"], req) do
    :elli_request.body(req)
    |> Person.insert()
    |> do_after_insert()
  end

  defp do_handle(:GET, ["pessoas", id], _req), do: Person.read(id)

  defp do_handle(:GET, ["pessoas"], req) do
    [{"t", search_term}] = :elli_request.get_args(req)
    {:ok, search_term}
  end

  defp do_handle(:GET, ["contagem-pessoas"], _req), do: {:ok, "COntagem"}

  def handle_event(_event, _data, _args), do: :ok

  defp do_after_insert({:ok, person}), do: {201, [{"Location", "/pessoas/#{person.id}"}], "success"}
  defp do_after_insert({:error, error_message}), do: {422, [], error_message}
end
