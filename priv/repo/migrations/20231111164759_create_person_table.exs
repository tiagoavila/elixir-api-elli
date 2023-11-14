defmodule RinhaBackend.Repo.Migrations.CreatePersonTable do
  use Ecto.Migration

  def change do
    create table(:person, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :apelido, :string, size: 32
      add :nome, :string, size: 100
      add :nascimento, :integer
      add :stack, :text
    end

    execute """
    CREATE INDEX person_fts_idx
    ON person
    USING GIN (
      to_tsvector('portuguese', apelido || ' ' || nome || ' ' || stack)
    );
    """
  end
end
