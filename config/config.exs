import Config

config :elixir_nebulex, ElixirNebulex.Cache,
  model: :inclusive,
  levels: [
    {
      ElixirNebulex.Cache.L1,
      gc_interval: :timer.hours(12), max_size: 1_000_000
    },
    {
      ElixirNebulex.Cache.L2,
      conn_opts: [
        host: "127.0.0.1",
        port: 6379
      ]
    }
  ]
