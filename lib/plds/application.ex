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

      # TODO: Should I start it hidden? If so, how?
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

    PLDS.Distribution.connect_to_nodes!(nodes)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PLDSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
