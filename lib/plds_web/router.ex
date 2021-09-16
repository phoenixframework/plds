defmodule PLDSWeb.Router do
  use PLDSWeb, :router
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery]
    live_dashboard "/", metrics: PLDSWeb.Telemetry
  end
end
