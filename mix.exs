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
      {:nebulex, "2.5.2"},
      {:nebulex_redis_adapter, "2.3.1"},
      {:tesla, "1.8.0"}
    ]
  end
end
