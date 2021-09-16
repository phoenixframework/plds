defmodule PLDSWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :plds

  @session_options [
    store: :cookie,
    key: "_plds_key",
    signing_salt: "LVKEVz/+"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    # Don't check the origin as we don't know how the web app is gonna be accessed.
    # It runs locally, but may be exposed via IP or domain name.
    # The WebSocket connection is already protected from CSWSH by using CSRF token.
    websocket: [check_origin: false, connect_info: [:user_agent, session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :plds,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:plds, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PLDSWeb.Router
end
