defmodule WeatherApp2.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WeatherApp2.Data` context.
  """

  @doc """
  Generate a measurement.
  """
  def measurement_fixture(attrs \\ %{}) do
    {:ok, measurement} =
      attrs
      |> Enum.into(%{
        atmospheric_pressure: 120.5,
        humidity: 120.5,
        river_level: 120.5,
        temperature: 120.5,
        wind_direction: "some wind_direction",
        wind_speed: 120.5
      })
      |> WeatherApp2.Data.create_measurement()

    measurement
  end

  @doc """
  Generate a daily_measurement.
  """
  def daily_measurement_fixture(attrs \\ %{}) do
    {:ok, daily_measurement} =
      attrs
      |> Enum.into(%{
        precipitation_of_the_day: 120.5
      })
      |> WeatherApp2.Data.create_daily_measurement()

    daily_measurement
  end
end
