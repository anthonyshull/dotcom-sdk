# DOTCOM SDK

An SDK for accessing data underlying https://mbta.com using the [MBTA SDK](https://github.com/anthonyshull/mbta-sdk).

## Installation

```elixir
defp deps do
  [
    {:dotcom_sdk, git: "git@github.com:anthonyshull/dotcom-sdk.git"}
  ]
end
```

## Configuration

The DOTCOM SDK relies on an underlying MBTA SDK; you'll need to configure both.

```elixir
# See more about Redis connection options at https://github.com/cabol/nebulex_redis_adapter
config :dotcom_sdk, DOTCOM.Api,
  conn_opts: [
    host: "127.0.0.1",
    port: 6379
  ]

# See more about Tesla connection options at https://github.com/elixir-tesla/tesla
config :tesla, MBTA.Connection,
  middleware: [
    {Tesla.Middleware.BaseUrl, System.get_env("V3_API_URL")},
    {Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}
  ]
```

Api caches are run separately.
So, you need to list all of the api modules you want to access as child processes.
In this example, we want access to Stop information.

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DOTCOM.Api.Stop
    ]

    opts = [strategy: :one_for_one, name: HelloMbta.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

## Usage

```elixir
defmodule MyApp.Stop do
  alias DOTCOM.Api.Stop

  @client MBTA.Connection.new()

  def get_stop(id) do
    Stop.api_web_stop_controller_show(@client, id).data.attributes
  end
end
```