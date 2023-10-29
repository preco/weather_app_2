defmodule WeatherApp2.DataTest do
  use WeatherApp2.DataCase

  alias WeatherApp2.Data

  describe "measurements" do
    alias WeatherApp2.Data.Measurement

    import WeatherApp2.DataFixtures

    @invalid_attrs %{temperature: nil, humidity: nil, atmospheric_pressure: nil, wind_speed: nil, wind_direction: nil, river_level: nil}

    test "list_measurements/0 returns all measurements" do
      measurement = measurement_fixture()
      assert Data.list_measurements() == [measurement]
    end

    test "get_measurement!/1 returns the measurement with given id" do
      measurement = measurement_fixture()
      assert Data.get_measurement!(measurement.id) == measurement
    end

    test "create_measurement/1 with valid data creates a measurement" do
      valid_attrs = %{temperature: 120.5, humidity: 120.5, atmospheric_pressure: 120.5, wind_speed: 120.5, wind_direction: "some wind_direction", river_level: 120.5}

      assert {:ok, %Measurement{} = measurement} = Data.create_measurement(valid_attrs)
      assert measurement.temperature == 120.5
      assert measurement.humidity == 120.5
      assert measurement.atmospheric_pressure == 120.5
      assert measurement.wind_speed == 120.5
      assert measurement.wind_direction == "some wind_direction"
      assert measurement.river_level == 120.5
    end

    test "create_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_measurement(@invalid_attrs)
    end

    test "update_measurement/2 with valid data updates the measurement" do
      measurement = measurement_fixture()
      update_attrs = %{temperature: 456.7, humidity: 456.7, atmospheric_pressure: 456.7, wind_speed: 456.7, wind_direction: "some updated wind_direction", river_level: 456.7}

      assert {:ok, %Measurement{} = measurement} = Data.update_measurement(measurement, update_attrs)
      assert measurement.temperature == 456.7
      assert measurement.humidity == 456.7
      assert measurement.atmospheric_pressure == 456.7
      assert measurement.wind_speed == 456.7
      assert measurement.wind_direction == "some updated wind_direction"
      assert measurement.river_level == 456.7
    end

    test "update_measurement/2 with invalid data returns error changeset" do
      measurement = measurement_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_measurement(measurement, @invalid_attrs)
      assert measurement == Data.get_measurement!(measurement.id)
    end

    test "delete_measurement/1 deletes the measurement" do
      measurement = measurement_fixture()
      assert {:ok, %Measurement{}} = Data.delete_measurement(measurement)
      assert_raise Ecto.NoResultsError, fn -> Data.get_measurement!(measurement.id) end
    end

    test "change_measurement/1 returns a measurement changeset" do
      measurement = measurement_fixture()
      assert %Ecto.Changeset{} = Data.change_measurement(measurement)
    end
  end

  describe "daily_measurements" do
    alias WeatherApp2.Data.DailyMeasurement

    import WeatherApp2.DataFixtures

    @invalid_attrs %{precipitation_of_the_day: nil}

    test "list_daily_measurements/0 returns all daily_measurements" do
      daily_measurement = daily_measurement_fixture()
      assert Data.list_daily_measurements() == [daily_measurement]
    end

    test "get_daily_measurement!/1 returns the daily_measurement with given id" do
      daily_measurement = daily_measurement_fixture()
      assert Data.get_daily_measurement!(daily_measurement.id) == daily_measurement
    end

    test "create_daily_measurement/1 with valid data creates a daily_measurement" do
      valid_attrs = %{precipitation_of_the_day: 120.5}

      assert {:ok, %DailyMeasurement{} = daily_measurement} = Data.create_daily_measurement(valid_attrs)
      assert daily_measurement.precipitation_of_the_day == 120.5
    end

    test "create_daily_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_daily_measurement(@invalid_attrs)
    end

    test "update_daily_measurement/2 with valid data updates the daily_measurement" do
      daily_measurement = daily_measurement_fixture()
      update_attrs = %{precipitation_of_the_day: 456.7}

      assert {:ok, %DailyMeasurement{} = daily_measurement} = Data.update_daily_measurement(daily_measurement, update_attrs)
      assert daily_measurement.precipitation_of_the_day == 456.7
    end

    test "update_daily_measurement/2 with invalid data returns error changeset" do
      daily_measurement = daily_measurement_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_daily_measurement(daily_measurement, @invalid_attrs)
      assert daily_measurement == Data.get_daily_measurement!(daily_measurement.id)
    end

    test "delete_daily_measurement/1 deletes the daily_measurement" do
      daily_measurement = daily_measurement_fixture()
      assert {:ok, %DailyMeasurement{}} = Data.delete_daily_measurement(daily_measurement)
      assert_raise Ecto.NoResultsError, fn -> Data.get_daily_measurement!(daily_measurement.id) end
    end

    test "change_daily_measurement/1 returns a daily_measurement changeset" do
      daily_measurement = daily_measurement_fixture()
      assert %Ecto.Changeset{} = Data.change_daily_measurement(daily_measurement)
    end
  end
end
