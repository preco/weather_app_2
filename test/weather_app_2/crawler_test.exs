defmodule WeatherApp2.CrawlerTest do
  use ExUnit.Case, async: true

  alias WeatherApp2.Crawler

  @fixture_file "test/fixtures/example.json"

  describe "conversoes" do
    test "to_celsius converte 86F para 30C" do
      assert {:ok, result} = Crawler.to_celsius(86)
      assert_in_delta(result, 30.0, 0.001)
    end

    test "inhg_to_hpa converte 29.92 inHg para 1013.25 hPa aproximado" do
      assert {:ok, result} = Crawler.inhg_to_hpa(29.92)
      assert_in_delta(result, 29.92 * 33.8639, 0.001)
    end

    test "mph_to_kmh converte 10 mph para 16.0934 km/h" do
      assert {:ok, result} = Crawler.mph_to_kmh(10)
      assert_in_delta(result, 16.0934, 0.0001)
    end

    test "degrees_to_cardinal retorna N para 359 graus" do
      assert {:ok, "N"} = Crawler.degrees_to_cardinal(359)
    end

    test "degrees_to_cardinal retorna N para 0 graus" do
      assert {:ok, "N"} = Crawler.degrees_to_cardinal(0)
    end

    test "degrees_to_cardinal retorna NNE para 20 graus" do
      assert {:ok, "NNE"} = Crawler.degrees_to_cardinal(20)
    end

    test "degrees_to_cardinal retorna L para 90 graus" do
      assert {:ok, "L"} = Crawler.degrees_to_cardinal(90)
    end
  end

  describe "build_measurement/1 e parsing de fixture" do
    test "constrói medicao valida a partir do JSON de fixture" do
      fixture = File.read!(@fixture_file) |> Jason.decode!()

      assert {:ok, measurement} = Crawler.build_measurement(fixture)

      assert_in_delta(measurement.temperature, (80.4 - 32) * 5 / 9, 0.01)
      assert_in_delta(measurement.humidity, 71.0, 0.01)
      assert_in_delta(measurement.atmospheric_pressure, 29.82 * 33.8639, 0.01)
      assert_in_delta(measurement.wind_speed, 4.9 * 1.60934, 0.01)
      assert measurement.wind_direction == "SSO"
      assert %NaiveDateTime{} = measurement.measured_at
    end
  end
end
