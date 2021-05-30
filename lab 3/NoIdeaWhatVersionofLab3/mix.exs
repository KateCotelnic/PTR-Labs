defmodule TwitterStream.MixProject do
  use Mix.Project

  def project do
    [
      app: :stream_app,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TweetRang.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mongodb, "~> 0.5.1"},
      {:eventsource_ex, "~> 0.0.2"},
      {:poison, "~> 1.4.0"},
#      {:mongodb_driver, "~> 0.6"},
#      {:mongodb, "~> 0.5.1"},
    ]
  end
end