defmodule PLDS.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PLDSWeb.Telemetry,
      {Phoenix.PubSub, name: PLDS.PubSub},
      PLDSWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PLDS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PLDSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
