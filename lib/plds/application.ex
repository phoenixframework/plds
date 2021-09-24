defmodule PLDS.Application do
  @moduledoc false

  @ensure_distribution Application.get_env(:plds, :ensure_distribution?, true)

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    ensure_distribution!()
    validate_hostname_resolution!()
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
    PLDS.Distribution.connect_to_nodes!()
  end

  # See https://github.com/livebook-dev/livebook/pull/303
  defp validate_hostname_resolution!() do
    unless PLDS.Utils.long_name?() do
      hostname = PLDS.Utils.node_host() |> to_charlist()

      if :inet.gethostbyname(hostname) == {:error, :nxdomain} do
        PLDS.Utils.abort!("""
        your hostname "#{hostname}" does not resolve to any IP address, which indicates something wrong in your OS configuration.

        Make sure your computer's name resolves locally or start PLDS using a long distribution name:

            plds server --name plds@127.0.0.1

        If you are running it from source, do instead:

            MIX_ENV=prod elixir --name plds@127.0.0.1 -S mix phx.server
        """)
      end
    end
  end

  @impl true
  def config_change(changed, _new, removed) do
    PLDSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
