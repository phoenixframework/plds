defmodule PLDS.Distribution do
  @moduledoc false

  require Logger

  # This module ensure that the application start as a node
  # and connect to the given nodes.

  def ensure_distribution! do
    unless Node.alive?() do
      case System.cmd("epmd", ["-daemon"]) do
        {_, 0} ->
          :ok

        _ ->
          PLDS.Utils.abort!("""
          could not start epmd (Erlang Port Mapper Driver). PLDS uses epmd to \
          talk to different runtimes. You may have to start epmd explicitly by calling:

              epmd -daemon

          Or by calling:

              elixir --sname test -e "IO.puts node()"

          Then you can try booting PLDS again
          """)
      end

      {type, name} = get_node_type_and_name()

      # NOTE: the node is started as hidden. Check `emu_args` in `mix.exs`.
      case Node.start(name, type) do
        {:ok, _} ->
          :ok

        {:error, reason} ->
          PLDS.Utils.abort!("could not start distributed node: #{inspect(reason)}")
      end
    end
  end

  defp get_node_type_and_name do
    Application.get_env(:plds, :node) || default_node_type_and_name()
  end

  # Choose for a short or long name based on connections.
  def default_node_type_and_name do
    if Enum.any?(nodes_to_connect(), &PLDS.Utils.long_name?(Atom.to_string(&1))) do
      name = :"plds@127.0.0.1"

      print_warning(
        "using long names because one of the nodes is long. Current name is #{inspect(name)}"
      )

      {:longnames, name}
    else
      {:shortnames, :plds}
    end
  end

  defp print_warning(message) do
    IO.ANSI.format([:yellow, "[PLDS] " <> message]) |> IO.puts()
  end

  defp nodes_to_connect do
    Application.get_env(:plds, :nodes_to_connect, [])
  end

  # Nodes can have long or short names.
  def connect_to_nodes!(nodes \\ nodes_to_connect()) do
    host = PLDS.Utils.node_host()

    # We get the current node host as host for when connect
    # only have shortnames
    for name <- nodes do
      name =
        if with_host?(name) do
          name
        else
          :"#{name}@#{host}"
        end

      connect_to(name)
    end

    :ok
  end

  defp with_host?(name) do
    name
    |> Atom.to_string()
    |> String.contains?("@")
  end

  defp connect_to(name) do
    if Node.connect(name) do
      Logger.info("[PLDS] Connected to node #{inspect(name)}")
    else
      PLDS.Utils.abort!("could not connect to node: #{inspect(name)}")
    end
  end
end
