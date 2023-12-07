defmodule ElixirNebulex.Cache do
  @moduledoc false

  use Nebulex.Cache, otp_app: :elixir_nebulex, adapter: Nebulex.Adapters.Multilevel

  defmodule L1 do
    use Nebulex.Cache, otp_app: :elixir_nebulex, adapter: Nebulex.Adapters.Local
  end

  defmodule L2 do
    use Nebulex.Cache, otp_app: :elixir_nebulex, adapter: NebulexRedisAdapter
  end
end
