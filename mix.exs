defmodule Suspicidy.MixProject do
  use Mix.Project

  def project do
    [
      app: :suspicidy,
      version: "0.1.0",
      elixir: "~> 1.8",
      name: "Suspicidy",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/suspicidy/suspicidy"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Phillipp Ohlandt"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/suspicidy/suspicidy"}
    ]
  end

  defp description do
    """
    Suspicidy aims to detect suspicious web requests. Currently, it only supports detection by
    request path, using a data-set of almost 800 paths collected from real web crawlers.
    """
  end

  defp deps do
    []
  end
end
