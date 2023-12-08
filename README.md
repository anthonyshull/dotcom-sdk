# DOTCOM SDK

An SDK for accessing data underlying https://mbta.com.

## Installation

```elixir
defp deps do
  [
    {:dotcom_sdk, git: "git@github.com:anthonyshull/dotcom-sdk.git"}
  ]
end
```

## Configuration

The DotcomSdk relies on an underlying MbtaSdk; you'll need to configure both.

```elixir
# config/config.exs

config :dotcom_sdk, DotcomSdk.Cache,
  conn_opts: [
    host: "127.0.0.1",
    port: 6379
  ]
```

```elixir
# config/runtime.exs
config :mbta, base_url: System.get_env("V3_API_URL")

config :tesla, MBTA.Connection,
  middleware: [{Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}]
```

Caches are run and supervised separately.
List all caches you want to access as child processes.
In this example, we want access to Stop information.

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DotcomSdk.Cache.Stop
    ]

    opts = [strategy: :one_for_one, name: HelloMbta.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

## Usage

```elixir
defmodule MyApp.Stop do
  alias DotcomSdk.Cache.Stop

  @client MBTA.Connection.new()

  def get_stop(id) do
    Stop.api_web_stop_controller_show(@client, id).data.attributes
  end
end
```