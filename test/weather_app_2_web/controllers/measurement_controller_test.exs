defmodule WeatherApp2Web.MeasurementControllerTest do
  use WeatherApp2Web.ConnCase

  import WeatherApp2.DataFixtures

  @create_attrs %{temperature: 120.5, humidity: 120.5, atmospheric_pressure: 120.5, wind_speed: 120.5, wind_direction: "some wind_direction", river_level: 120.5}
  @update_attrs %{temperature: 456.7, humidity: 456.7, atmospheric_pressure: 456.7, wind_speed: 456.7, wind_direction: "some updated wind_direction", river_level: 456.7}
  @invalid_attrs %{temperature: nil, humidity: nil, atmospheric_pressure: nil, wind_speed: nil, wind_direction: nil, river_level: nil}

  describe "index" do
    test "lists all measurements", %{conn: conn} do
      conn = get(conn, ~p"/measurements")
      assert html_response(conn, 200) =~ "Listing Measurements"
    end
  end

  describe "new measurement" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/measurements/new")
      assert html_response(conn, 200) =~ "New Measurement"
    end
  end

  describe "create measurement" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/measurements", measurement: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/measurements/#{id}"

      conn = get(conn, ~p"/measurements/#{id}")
      assert html_response(conn, 200) =~ "Measurement #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/measurements", measurement: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Measurement"
    end
  end

  describe "edit measurement" do
    setup [:create_measurement]

    test "renders form for editing chosen measurement", %{conn: conn, measurement: measurement} do
      conn = get(conn, ~p"/measurements/#{measurement}/edit")
      assert html_response(conn, 200) =~ "Edit Measurement"
    end
  end

  describe "update measurement" do
    setup [:create_measurement]

    test "redirects when data is valid", %{conn: conn, measurement: measurement} do
      conn = put(conn, ~p"/measurements/#{measurement}", measurement: @update_attrs)
      assert redirected_to(conn) == ~p"/measurements/#{measurement}"

      conn = get(conn, ~p"/measurements/#{measurement}")
      assert html_response(conn, 200) =~ "some updated wind_direction"
    end

    test "renders errors when data is invalid", %{conn: conn, measurement: measurement} do
      conn = put(conn, ~p"/measurements/#{measurement}", measurement: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Measurement"
    end
  end

  describe "delete measurement" do
    setup [:create_measurement]

    test "deletes chosen measurement", %{conn: conn, measurement: measurement} do
      conn = delete(conn, ~p"/measurements/#{measurement}")
      assert redirected_to(conn) == ~p"/measurements"

      assert_error_sent 404, fn ->
        get(conn, ~p"/measurements/#{measurement}")
      end
    end
  end

  defp create_measurement(_) do
    measurement = measurement_fixture()
    %{measurement: measurement}
  end
end
