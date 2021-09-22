defmodule PLDSWeb.HealthController do
  use PLDSWeb, :controller

  @moduledoc false

  def index(conn, _) do
    version = Application.spec(:plds, :vsn) |> List.to_string()

    json(conn, %{
      "application" => "plds",
      "version" => version
    })
  end
end
