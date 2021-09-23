defmodule PLDS.Application do
  @moduledoc false

  @ensure_distribution Application.get_env(:plds, :ensure_distribution?, true)

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    ensure_distribution!()
    connect_to_nodes!()

    children = [
      {Phoenix.PubSub, name: PLDS.PubSub},
      PLDSWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PLDS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # We want to avoid to execute this in test env.
  if @ensure_distribution do
    defp ensure_distribution! do
      PLDS.Distribution.ensure_distribution!()

      if cookie = Application.get_env(:plds, :cookie) do
        Node.set_cookie(cookie)
      end
    end
  else
    defp ensure_distribution!, do: :noop
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
