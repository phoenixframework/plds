defmodule PLDSWeb.HealthControllerTest do
  use PLDSWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")

    assert %{"application" => "plds", "version" => _} = json_response(conn, 200)
  end
end
