import Config

config :tesla, MBTA.Connection,
  middleware: [{Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}]
