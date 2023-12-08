alias MBTA.Api, as: Api
alias DotcomSdk.Cache, as: Cache

client = MBTA.Connection.new(base_url: System.get_env("V3_API_URL"))

DynamicSupervisor.start_child(DotcomSdk.DynamicSupervisor, Cache.Stop)

# Api.Stop.api_web_stop_controller_show(client, "place-sstat")
# Cache.Stop.api_web_stop_controller_show(client, "place-sstat")
