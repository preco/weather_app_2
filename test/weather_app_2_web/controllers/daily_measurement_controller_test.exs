defmodule WeatherApp2Web.DailyMeasurementControllerTest do
  use WeatherApp2Web.ConnCase

  import WeatherApp2.DataFixtures

  @create_attrs %{precipitation_of_the_day: 120.5}
  @update_attrs %{precipitation_of_the_day: 456.7}
  @invalid_attrs %{precipitation_of_the_day: nil}

  describe "index" do
    test "lists all daily_measurements", %{conn: conn} do
      conn = get(conn, ~p"/daily_measurements")
      assert html_response(conn, 200) =~ "Listing Daily measurements"
    end
  end

  describe "new daily_measurement" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/daily_measurements/new")
      assert html_response(conn, 200) =~ "New Daily measurement"
    end
  end

  describe "create daily_measurement" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/daily_measurements", daily_measurement: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/daily_measurements/#{id}"

      conn = get(conn, ~p"/daily_measurements/#{id}")
      assert html_response(conn, 200) =~ "Daily measurement #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/daily_measurements", daily_measurement: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Daily measurement"
    end
  end

  describe "edit daily_measurement" do
    setup [:create_daily_measurement]

    test "renders form for editing chosen daily_measurement", %{conn: conn, daily_measurement: daily_measurement} do
      conn = get(conn, ~p"/daily_measurements/#{daily_measurement}/edit")
      assert html_response(conn, 200) =~ "Edit Daily measurement"
    end
  end

  describe "update daily_measurement" do
    setup [:create_daily_measurement]

    test "redirects when data is valid", %{conn: conn, daily_measurement: daily_measurement} do
      conn = put(conn, ~p"/daily_measurements/#{daily_measurement}", daily_measurement: @update_attrs)
      assert redirected_to(conn) == ~p"/daily_measurements/#{daily_measurement}"

      conn = get(conn, ~p"/daily_measurements/#{daily_measurement}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, daily_measurement: daily_measurement} do
      conn = put(conn, ~p"/daily_measurements/#{daily_measurement}", daily_measurement: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Daily measurement"
    end
  end

  describe "delete daily_measurement" do
    setup [:create_daily_measurement]

    test "deletes chosen daily_measurement", %{conn: conn, daily_measurement: daily_measurement} do
      conn = delete(conn, ~p"/daily_measurements/#{daily_measurement}")
      assert redirected_to(conn) == ~p"/daily_measurements"

      assert_error_sent 404, fn ->
        get(conn, ~p"/daily_measurements/#{daily_measurement}")
      end
    end
  end

  defp create_daily_measurement(_) do
    daily_measurement = daily_measurement_fixture()
    %{daily_measurement: daily_measurement}
  end
end
