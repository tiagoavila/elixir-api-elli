defmodule RinhaBackend.Person do
  use Ecto.Schema

  schema "person" do
    field :apelido, :string
    field :nome, :string
    field :nascimento, :string
    field :stack, :string
  end
end
