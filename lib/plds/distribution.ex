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
    Application.get_env(:plds, :node) || {:shortnames, :plds}
  end

  # Nodes can be long or short names.
  def connect_to_nodes!(nodes) do
    [_, host] =
      node()
      |> Atom.to_string()
      |> String.split("@")

    # We get the current node host as host for when connect
    # only have shortnames
    for name <- nodes do
      name =
        if long_name?(name) do
          name
        else
          :"#{name}@#{host}"
        end

      connect_to(name)
    end

    :ok
  end

  defp long_name?(name) do
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
