defmodule WeatherApp2Web.MeasurementController do
  use WeatherApp2Web, :controller

  alias WeatherApp2.Data
  alias WeatherApp2.Data.Measurement

  def index(conn, _params) do
    WeatherApp2.Crawler.get_url_info()
    measurements = Data.list_measurements()
    render(conn, :index, measurements: measurements)
  end

  def new(conn, _params) do
    changeset = Data.change_measurement(%Measurement{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"measurement" => measurement_params}) do
    case Data.create_measurement(measurement_params) do
      {:ok, measurement} ->
        conn
        |> put_flash(:info, "Measurement created successfully.")
        |> redirect(to: ~p"/measurements/#{measurement}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    measurement = Data.get_measurement!(id)
    render(conn, :show, measurement: measurement)
  end

  def edit(conn, %{"id" => id}) do
    measurement = Data.get_measurement!(id)
    changeset = Data.change_measurement(measurement)
    render(conn, :edit, measurement: measurement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "measurement" => measurement_params}) do
    measurement = Data.get_measurement!(id)

    case Data.update_measurement(measurement, measurement_params) do
      {:ok, measurement} ->
        conn
        |> put_flash(:info, "Measurement updated successfully.")
        |> redirect(to: ~p"/measurements/#{measurement}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, measurement: measurement, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    measurement = Data.get_measurement!(id)
    {:ok, _measurement} = Data.delete_measurement(measurement)

    conn
    |> put_flash(:info, "Measurement deleted successfully.")
    |> redirect(to: ~p"/measurements")
  end
end
