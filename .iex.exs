client = MBTA.Connection.new()

DynamicSupervisor.start_child(DOTCOM.DynamicSupervisor, DOTCOM.Api.Stop)

# MBTA.Api.Stop.api_web_stop_controller_show(client, "place-sstat")
# MBTA.Api.Stop.api_web_stop_controller_show(client, "place-brntn")

# DOTCOM.Api.Stop.api_web_stop_controller_show(client, "place-sstat")
# DOTCOM.Api.Stop.api_web_stop_controller_show(client, "place-brntn")
