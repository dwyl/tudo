use Mix.Config

config :tudo, :httpoison, Tudo.HTTPoison.InMemory

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tudo, Tudo.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tudo, Tudo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "tudo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 10 * 60 * 1000
