defmodule ElixirNebulex.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_nebulex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirNebulex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:decorator, "1.4.0"},
      {:jason, "1.4.1"},
      {:logster, "2.0.0-rc.3"},
      {:mbta, path: "../mbta"},
      {:nebulex, "2.5.2"},
      {:nebulex_redis_adapter, "2.3.1"}
    ]
  end
end
