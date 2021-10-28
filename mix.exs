defmodule PLDS.MixProject do
  use Mix.Project

  @version "0.1.2"
  @description "CLI version of Phoenix LiveDashboard"

  def project do
    [
      app: :plds,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "PLDS",
      description: @description,
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      package: package(),
      aliases: aliases(),
      escript: escript(),
      docs: docs(),
      deps: with_lock(deps())
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

  # Although we use requirements here, the with_lock() function
  # below ensures we only use the locked versions. This is important
  # because we don't want users to potentially get a new dependency
  # when installing from git or as an escript.
  #
  # Therefore, to update any dependency, you must call before:
  #
  #     mix deps.unlock foo bar baz
  #

  defp deps do
    [
      {:phoenix, "~> 1.5.13 or ~> 1.6.0"},
      {:phoenix_live_dashboard, "~> 0.5.2", phoenix_live_dashboard_opts()},
      {:ecto_psql_extras, "~> 0.7"},
      {:broadway_dashboard, "~> 0.2.1"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:ex_doc, "~> 0.25.3", only: :dev}
    ]
  end

  @lock (with {:ok, contents} <- File.read("mix.lock"),
              {:ok, quoted} <- Code.string_to_quoted(contents, warn_on_unnecessary_quotes: false),
              {%{} = lock, _binding} <- Code.eval_quoted(quoted, []) do
           for {dep, hex} when elem(hex, 0) == :hex <- lock,
               do: {dep, elem(hex, 2)},
               into: %{}
         else
           _ -> %{}
         end)

  defp with_lock(deps) do
    for dep <- deps do
      name = elem(dep, 0)
      put_elem(dep, 1, @lock[name] || elem(dep, 1))
    end
  end

  defp phoenix_live_dashboard_opts do
    if path = System.get_env("LIVE_DASHBOARD_PATH") do
      [path: path, override: true]
    else
      []
    end
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

  defp docs do
    [
      main: "PLDS",
      source_ref: "v#{@version}",
      source_url: "https://github.com/phoenixframework/plds",
      homepage_url: "https://www.phoenixframework.org/"
    ]
  end

  defp package do
    %{
      maintainers: ["Philip Sampaio"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/phoenixframework/plds",
        "Phoenix website" => "https://www.phoenixframework.org"
      },
      files: ~w(lib config CHANGELOG.md LICENSE.md mix.exs mix.lock README.md)
    }
  end
end
