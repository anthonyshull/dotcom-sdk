import Config

config :dotcom_sdk, DOTCOM.Api,
  conn_opts: [
    host: "127.0.0.1",
    port: 6379
  ]

config :dotcom_sdk,
  dotcom_api_stop: 5_000,
  api_web_stop_controller_show: 10_000

config :tesla, MBTA.Connection,
  middleware: [
    {Tesla.Middleware.BaseUrl, System.get_env("V3_API_URL")},
    {Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}
  ]
