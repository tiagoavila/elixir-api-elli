import Config

config :elixir_api_elli, RinhaBackend.Repo,
  database: "elixir_api_elli_repo",
  username: "postgres",
  password: "123456",
  hostname: "localhost"

  config :elixir_api_elli, ecto_repos: [RinhaBackend.Repo]
