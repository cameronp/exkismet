defmodule Exkismet.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exkismet,
      version: "0.0.3",
      elixir: "~> 1.10",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["Cameron Price"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cameronp/exkismet"}
    ]
  end

  defp description do
    """
    A client (completely unofficial) for the Akismet.com comment-spam detection API.
    """
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    []
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:ex_doc, "~> 0.29", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.21.0", only: :dev},
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false}
    ]
  end
end
