defmodule WeatherApp2.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias WeatherApp2.Repo

  alias WeatherApp2.Data.Measurement

  @doc """
  Returns the list of measurements.

  ## Examples

      iex> list_measurements()
      [%Measurement{}, ...]

  """
  def list_measurements do
    Repo.all(Measurement)
  end

  @doc """
  Gets a single measurement.

  Raises `Ecto.NoResultsError` if the Measurement does not exist.

  ## Examples

      iex> get_measurement!(123)
      %Measurement{}

      iex> get_measurement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_measurement!(id), do: Repo.get!(Measurement, id)

  @doc """
  Creates a measurement.

  ## Examples

      iex> create_measurement(%{field: value})
      {:ok, %Measurement{}}

      iex> create_measurement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_measurement(attrs \\ %{}) do
    %Measurement{}
    |> Measurement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a measurement.

  ## Examples

      iex> update_measurement(measurement, %{field: new_value})
      {:ok, %Measurement{}}

      iex> update_measurement(measurement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_measurement(%Measurement{} = measurement, attrs) do
    measurement
    |> Measurement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a measurement.

  ## Examples

      iex> delete_measurement(measurement)
      {:ok, %Measurement{}}

      iex> delete_measurement(measurement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_measurement(%Measurement{} = measurement) do
    Repo.delete(measurement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking measurement changes.

  ## Examples

      iex> change_measurement(measurement)
      %Ecto.Changeset{data: %Measurement{}}

  """
  def change_measurement(%Measurement{} = measurement, attrs \\ %{}) do
    Measurement.changeset(measurement, attrs)
  end

  alias WeatherApp2.Data.DailyMeasurement

  @doc """
  Returns the list of daily_measurements.

  ## Examples

      iex> list_daily_measurements()
      [%DailyMeasurement{}, ...]

  """
  def list_daily_measurements do
    Repo.all(DailyMeasurement)
  end

  @doc """
  Gets a single daily_measurement.

  Raises `Ecto.NoResultsError` if the Daily measurement does not exist.

  ## Examples

      iex> get_daily_measurement!(123)
      %DailyMeasurement{}

      iex> get_daily_measurement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_measurement!(id), do: Repo.get!(DailyMeasurement, id)

  @doc """
  Creates a daily_measurement.

  ## Examples

      iex> create_daily_measurement(%{field: value})
      {:ok, %DailyMeasurement{}}

      iex> create_daily_measurement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_measurement(attrs \\ %{}) do
    %DailyMeasurement{}
    |> DailyMeasurement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a daily_measurement.

  ## Examples

      iex> update_daily_measurement(daily_measurement, %{field: new_value})
      {:ok, %DailyMeasurement{}}

      iex> update_daily_measurement(daily_measurement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_measurement(%DailyMeasurement{} = daily_measurement, attrs) do
    daily_measurement
    |> DailyMeasurement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a daily_measurement.

  ## Examples

      iex> delete_daily_measurement(daily_measurement)
      {:ok, %DailyMeasurement{}}

      iex> delete_daily_measurement(daily_measurement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_measurement(%DailyMeasurement{} = daily_measurement) do
    Repo.delete(daily_measurement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_measurement changes.

  ## Examples

      iex> change_daily_measurement(daily_measurement)
      %Ecto.Changeset{data: %DailyMeasurement{}}

  """
  def change_daily_measurement(%DailyMeasurement{} = daily_measurement, attrs \\ %{}) do
    DailyMeasurement.changeset(daily_measurement, attrs)
  end
end
