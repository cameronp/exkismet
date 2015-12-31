defmodule Exkismet.Mixfile do
  use Mix.Project

  def project do
    [app: :exkismet,
     version: "0.0.1",
     elixir: "~> 1.1",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
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
    A client (completely unofficial) for the Akismet.com comment-spam detection
    API.
    """
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison],
     mod: {Exkismet, []}]
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
     {:httpoison, "~> 0.8.0"},
     {:poison, "~> 1.5"}
    ]
  end
end
