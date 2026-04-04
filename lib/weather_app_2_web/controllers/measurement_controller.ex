defmodule WeatherApp2Web.MeasurementController do
  use WeatherApp2Web, :controller

  alias WeatherApp2.Data
  alias WeatherApp2.Data.Measurement

  def index(conn, %{"page" => page_param} = _params) do
    page = parse_page(page_param)
    pagination = Data.list_measurements_paginated(page)
    render(conn, :index, measurements: pagination.entries, pagination: pagination)
  end

  def index(conn, _params) do
    pagination = Data.list_measurements_paginated(1)
    render(conn, :index, measurements: pagination.entries, pagination: pagination)
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

  def fetch_from_crawler(conn, _params) do
    case WeatherApp2.Crawler.get_url_info() do
      {:ok, _measurement} ->
        conn
        |> put_flash(:info, "Medicao obtida e salva com sucesso.")
        |> redirect(to: ~p"/measurements")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Falha ao obter medicao: #{inspect(reason)}")
        |> redirect(to: ~p"/measurements")
    end
  end

  defp parse_page(value) when is_binary(value) do
    case Integer.parse(value) do
      {n, ""} when n > 0 -> n
      _ -> 1
    end
  end

  defp parse_page(_), do: 1
end
