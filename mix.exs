defmodule AdeptEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :adept_ecto,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      # {:adept, git: "git@github.com:adept-bits/adept.git"}
      {:adept, git: "https://github.com/adept-bits/adept.git"}
    ]
  end
end
