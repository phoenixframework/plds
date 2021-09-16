defmodule PLDSWeb.Router do
  use PLDSWeb, :router
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery]

    get "/health", PLDSWeb.HealthController, :index

    live_dashboard "/",
      metrics: PLDSWeb.Telemetry,
      additional_pages: [broadway: BroadwayDashboard]
  end
end
