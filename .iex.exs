alias MBTA.Api, as: Api
alias ElixirNebulex.Cache, as: Cache

client = MBTA.Connection.new()

config = Application.get_env(:elixir_nebulex, ElixirNebulex.Cache)

DynamicSupervisor.start_child(ElixirNebulex.DynamicSupervisor, Cache.Stop)

# Api.Stop.api_web_stop_controller_show(client, "place-sstat")
# Cache.Stop.api_web_stop_controller_show(client, "place-sstat")

# Benchee.run(%{api: api, cache: cache})
