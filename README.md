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

See more about Redis connection options at https://github.com/cabol/nebulex_redis_adapter.

```elixir
config :dotcom_sdk, DOTCOM.Api,
  conn_opts: [
    host: "127.0.0.1",
    port: 6379
  ]
```

You can also set unique TTLs for every submodule and/or function.
Function settings will override submodule settings.
The default TTL is :infinity.

```elixir
config :dotcom_sdk,
  dotcom_api_stop: 5_000, # sets the DOTCOM.Api.Stop TTL to 5 seconds
  api_web_stop_controller_show: 10_000 # sets the function specific TTL to 10 seconds
```

The MBTA SDK uses Tesla for its HTTP handling.
At a minimum, you'll need to set the base URL.
See more about Tesla connection options at https://github.com/elixir-tesla/tesla.

```elixir
config :tesla, MBTA.Connection,
  middleware: [
    {Tesla.Middleware.BaseUrl, System.get_env("V3_API_URL")},
    {Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}
  ]
```

Api caches are run separately.
So, you need to list all of the api modules you want to access as child processes.
In this example, we just want access to Stop information.

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

You can use `DOTCOM.Api.submodules()` to return a list of all submodules in the SDK.

```elixir
# ...
    Supervisor.start_link(DOTCOM.Api.submodules(), opts)
# ...
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