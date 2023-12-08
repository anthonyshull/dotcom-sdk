defmodule ElixirNebulex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Supervisor.start_link(
      [{DynamicSupervisor, strategy: :one_for_one, name: ElixirNebulex.DynamicSupervisor}],
      strategy: :one_for_one
    )
  end
end
