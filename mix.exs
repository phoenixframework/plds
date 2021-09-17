defmodule PLDS.MixProject do
  use Mix.Project

  def project do
    [
      app: :plds,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      escript: escript(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PLDS.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon, :inets]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.6.0-rc.0", override: true},
      {:phoenix_live_dashboard, path: "../phoenix_live_dashboard", override: true},
      {:ecto_psql_extras, "~> 0.7"},
      {:broadway_dashboard, "~> 0.2.1"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  defp aliases do
    [
      # TODO: loadconfig no longer required on Elixir v1.13
      # Currently this ensures we load configuration before
      # compiling dependencies as part of `mix escript.install`.
      # See https://github.com/elixir-lang/elixir/commit/a6eefb244b3a5892895a97b2dad4cce2b3c3c5ed
      "escript.build": ["loadconfig", "escript.build"],
      setup: ["deps.get"]
    ]
  end

  defp escript do
    [
      main_module: PLDSCli,
      emu_args: "-hidden",
      app: nil
    ]
  end
end
