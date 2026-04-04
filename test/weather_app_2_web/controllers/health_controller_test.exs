defmodule WeatherApp2Web.HealthControllerTest do
  use WeatherApp2Web.ConnCase

  describe "GET /health" do
    test "retorna 200 com status ok", %{conn: conn} do
      conn = get(conn, ~p"/health")

      assert conn.status == 200
      assert %{"status" => "ok"} = json_response(conn, 200)
    end
  end
end