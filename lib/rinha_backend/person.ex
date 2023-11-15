defmodule RinhaBackend.Person do
  use Ecto.Schema

  alias RinhaBackend.EtsCache

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "person" do
    field :apelido, :string
    field :nome, :string
    field :nascimento, :string
    field :stack, :string
  end

  def insert(person_body) do
    person = Jason.decode!(person_body, keys: :atoms)

    if validate(person) do
      insert_person_result = %RinhaBackend.Person{
        apelido: person.apelido,
        nome: person.nome,
        nascimento: person.nascimento,
        stack: parse_stack_to_string(person.stack)}
      |> RinhaBackend.Repo.insert()

      case insert_person_result do
        {:ok, created_person} ->
          EtsCache.insert(created_person.apelido)

          person_json = Map.put(person, :id, created_person.id) |> Jason.encode!()
          EtsCache.insert(created_person.id, person_json)

          {:ok, created_person}

        {:error, %Ecto.Changeset{} = _changeset} -> {:error, "changeset error"}
      end

    else
      {:error, "invalid data"}
    end
  end

  defp validate(person) do
    with true <- validate_nickname(person.apelido),
         true <- check_nickname_is_unique(person.apelido),
         true <- validate_name(person.nome),
         true <- validate_birth_date(person.nascimento),
         true <- validate_stack(person.stack)
    do
      true
    else
      _ -> false
    end
  end

  defp validate_nickname(nil), do: false
  defp validate_nickname(nickname) when is_binary(nickname), do: if String.length(nickname) <= 32, do: true, else: false
  defp validate_nickname(_), do: false

  defp check_nickname_is_unique(nickname), do: if EtsCache.exists?(nickname), do: false, else: true

  defp validate_name(nil), do: false
  defp validate_name(name) when is_binary(name), do: if String.length(name) <= 100, do: true, else: false
  defp validate_name(_), do: false

  defp validate_birth_date(nil), do: false
  defp validate_birth_date(_), do: true

  defp validate_stack(nil), do: true
  defp validate_stack(stack), do: Enum.all?(stack, &is_binary/1)

  defp parse_stack_to_string(nil), do: ""
  defp parse_stack_to_string(stack), do: Enum.join(stack, " ")
end
