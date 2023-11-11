defmodule RinhaBackend.Repo do
  use Ecto.Repo,
    otp_app: :elixir_api_elli,
    adapter: Ecto.Adapters.Postgres
end
