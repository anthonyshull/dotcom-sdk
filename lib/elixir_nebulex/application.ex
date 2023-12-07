defmodule ElixirNebulex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Supervisor.start_link([ElixirNebulex.Cache],
      strategy: :one_for_one,
      name: ElixirNebulex.Supervisor
    )
  end
end
