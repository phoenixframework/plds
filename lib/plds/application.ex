defmodule PLDS.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    ensure_distribution!()
    set_cookie()
    connect_to_nodes!()

    children = [
      PLDSWeb.Telemetry,
      {Phoenix.PubSub, name: PLDS.PubSub},
      PLDSWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PLDS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp ensure_distribution! do
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

      # TODO: Should I start it hidden?
      case Node.start(name, type) do
        {:ok, _} ->
          :ok

        {:error, reason} ->
          PLDS.Utils.abort!("could not start distributed node: #{inspect(reason)}")
      end
    end
  end

  defp set_cookie do
    cookie = Application.fetch_env!(:plds, :cookie)
    Node.set_cookie(cookie)
  end

  defp get_node_type_and_name do
    Application.get_env(:plds, :node) || {:shortnames, :plds}
  end

  defp connect_to_nodes! do
    nodes = Application.get_env(:plds, :nodes_to_connect, [])
    node_name = Atom.to_string(node())
    [_, host] = String.split(node_name, "@")

    # We get the current node host as host for when connect
    # only have shortnames
    for name <- nodes do
      name =
        if String.contains?(Atom.to_string(name), "@") do
          name
        else
          String.to_atom("#{name}@#{host}")
        end

      connect_to(name)
    end
  end

  defp connect_to(name) do
    if Node.connect(name) do
      Logger.info("[PLDS] Connected to node #{inspect(name)}")
    else
      PLDS.Utils.abort!("could not connect to node: #{inspect(name)}")
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PLDSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
