import Config

config :elixir_nebulex, ElixirNebulex.Cache,
  conn_opts: [
    host: "127.0.0.1",
    port: 6379
  ]

config :logster, format: :string

config :mbta, base_url: "https://api-dev.mbtace.com"

config :tesla, MBTA.Connection,
  middleware: [{Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}]
