defmodule DotcomSdk.MixProject do
  use Mix.Project

  def project do
    [
      app: :dotcom_sdk,
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
      mod: {DOTCOM.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:decorator, "1.4.0"},
      {:logster, "2.0.0-rc.3"},
      {:mbta_sdk, git: "git@github.com:anthonyshull/mbta-sdk.git"},
      {:nebulex, "2.5.2"},
      {:nebulex_redis_adapter, "2.3.1"}
    ]
  end
end
