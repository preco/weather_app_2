defmodule WeatherApp2Web.DailyMeasurementController do
  use WeatherApp2Web, :controller

  alias WeatherApp2.Data
  alias WeatherApp2.Data.DailyMeasurement

  def index(conn, %{"page" => page_param} = _params) do
    page = parse_page(page_param)
    pagination = Data.list_daily_measurements_paginated(page)
    render(conn, :index, daily_measurements: pagination.entries, pagination: pagination)
  end

  def index(conn, _params) do
    pagination = Data.list_daily_measurements_paginated(1)
    render(conn, :index, daily_measurements: pagination.entries, pagination: pagination)
  end

  def new(conn, _params) do
    changeset = Data.change_daily_measurement(%DailyMeasurement{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"daily_measurement" => daily_measurement_params}) do
    case Data.create_daily_measurement(daily_measurement_params) do
      {:ok, daily_measurement} ->
        conn
        |> put_flash(:info, "Daily measurement created successfully.")
        |> redirect(to: ~p"/daily_measurements/#{daily_measurement}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    daily_measurement = Data.get_daily_measurement!(id)
    render(conn, :show, daily_measurement: daily_measurement)
  end

  def edit(conn, %{"id" => id}) do
    daily_measurement = Data.get_daily_measurement!(id)
    changeset = Data.change_daily_measurement(daily_measurement)
    render(conn, :edit, daily_measurement: daily_measurement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "daily_measurement" => daily_measurement_params}) do
    daily_measurement = Data.get_daily_measurement!(id)

    case Data.update_daily_measurement(daily_measurement, daily_measurement_params) do
      {:ok, daily_measurement} ->
        conn
        |> put_flash(:info, "Daily measurement updated successfully.")
        |> redirect(to: ~p"/daily_measurements/#{daily_measurement}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, daily_measurement: daily_measurement, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    daily_measurement = Data.get_daily_measurement!(id)
    {:ok, _daily_measurement} = Data.delete_daily_measurement(daily_measurement)

    conn
    |> put_flash(:info, "Daily measurement deleted successfully.")
    |> redirect(to: ~p"/daily_measurements")
  end

  defp parse_page(value) when is_binary(value) do
    case Integer.parse(value) do
      {n, ""} when n > 0 -> n
      _ -> 1
    end
  end

  defp parse_page(_), do: 1
end
