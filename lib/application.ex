defmodule ElixirApiElli.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias ElixirApiElli.ElliCallback

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ElixirApiElli.Worker.start_link(arg)
      # {ElixirApiElli.Worker, arg}
      %{
        id: :elli,
        start: {:elli, :start_link, [ [ callback: ElliCallback, port: 3000 ]]}
      },
      RinhaBackend.EtsCache,
      RinhaBackend.Repo,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirApiElli.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
