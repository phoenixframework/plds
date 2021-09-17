defmodule PLDSCli do
  @moduledoc false

  def usage do
    """
    Usage: plds [command] [options]

    Available commands:

      plds server    Starts the PLDS web application

    The --help and --version options can be given instead of a command for usage and versioning information.
    """
  end

  def main(args) do
    {:ok, _} = Application.ensure_all_started(:elixir)
    :ok = Application.load(:plds)

    if unix?() do
      Application.put_env(:elixir, :ansi_enabled, true)
    end

    call(args)
  end

  defp unix?, do: match?({:unix, _}, :os.type())

  defp call([arg]) when arg in ["--help", "-h"], do: display_help()
  defp call([arg]) when arg in ["--version", "-v"], do: display_version()

  defp call([task_name | args]) do
    case find_task(task_name) do
      nil ->
        IO.ANSI.format([:red, "Unknown command #{task_name}\n"]) |> IO.puts()
        IO.write(usage())

      task ->
        call_task(task, args)
    end
  end

  defp call(_args), do: IO.write(usage())

  defp find_task("server"), do: PLDSCli.Server
  defp find_task(_), do: nil

  defp call_task(task, [arg]) when arg in ["--help", "-h"] do
    IO.write(task.usage())
  end

  defp call_task(task, args) do
    try do
      task.call(args)
    rescue
      error ->
        IO.ANSI.format([:red, Exception.message(error), "\n"]) |> IO.puts()
        IO.write(task.usage())
    end
  end

  defp display_help do
    IO.puts("PLDS a bundle of Phoenix Live Dashboard with some batteries included.\n")
    IO.write(usage())
  end

  defp display_version do
    IO.puts(:erlang.system_info(:system_version))
    IO.puts("Elixir " <> System.build_info()[:build])

    version = Application.spec(:plds, :vsn)
    IO.puts("\nPLDS #{version}")
  end
end
