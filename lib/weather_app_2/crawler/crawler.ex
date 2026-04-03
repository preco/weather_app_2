defmodule WeatherApp2.Crawler do
  @moduledoc """
  Modulo responsavel por obter os valores das mediciones do endpoint JSON.
  """

  require Logger

  @endpoint "https://plantaragronomia.eng.br/ecowiit-realtime?region=tubarao"

  @doc "Busca e persiste um registro de medicao a partir do endpoint remoto."
  def get_url_info do
    with {:ok, payload} <- fetch_json(),
         {:ok, measurement} <- build_measurement(payload),
         {:ok, _record} <- WeatherApp2.Data.create_measurement(Map.from_struct(measurement)) do
      Logger.info("Medicao salva: #{inspect(measurement)}")
      {:ok, measurement}
    else
      {:error, reason} = error ->
        Logger.error("Falha na ingestao de medicao: #{inspect(reason)}")
        error
    end
  end

  @doc "Busca o JSON do endpoint e decodifica para map."
  def fetch_json do
    Finch.build(:get, @endpoint)
    |> Finch.request(WeatherApp2.Finch)
    |> case do
      {:ok, %Finch.Response{status: 200, body: body}} -> Jason.decode(body)
      {:ok, %Finch.Response{status: status}} -> {:error, {:http_status, status}}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc "Constrói a struct Measurement do JSON recebido."
  def build_measurement(%{"data" => data}) do
    with {:ok, temp_f} <- fetch_in_value(data, ["outdoor", "temperature", "value"]),
         {:ok, humidity} <- fetch_in_value(data, ["outdoor", "humidity", "value"]),
         {:ok, pressure_inhg} <- fetch_in_value(data, ["pressure", "relative", "value"]),
         {:ok, wind_mph} <- fetch_in_value(data, ["wind", "wind_speed", "value"]),
         {:ok, wind_deg} <- fetch_in_value(data, ["wind", "wind_direction", "value"]),
         {:ok, time_unix} <- fetch_in_value(data, ["outdoor", "temperature", "time"]),
         {:ok, temperature} <- to_celsius(temp_f),
         {:ok, atmospheric_pressure} <- inhg_to_hpa(pressure_inhg),
         {:ok, wind_speed} <- mph_to_kmh(wind_mph),
         {:ok, wind_direction} <- degrees_to_cardinal(wind_deg),
         {:ok, measured_at} <- parse_measured_at(time_unix) do
      {:ok,
       %WeatherApp2.Data.Measurement{
         temperature: temperature,
         humidity: humidity,
         atmospheric_pressure: atmospheric_pressure,
         wind_speed: wind_speed,
         wind_direction: wind_direction,
         river_level: 0.0,
         measured_at: measured_at
       }}
    end
  end

  defp fetch_in_value(data, path) do
    case get_in(data, path) do
      nil -> {:error, {:missing_field, path}}
      value -> to_number(value)
    end
  end

  defp to_number(value) when is_number(value), do: {:ok, value}

  defp to_number(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> {:ok, num}
      :error -> {:error, {:parse_number_error, value}}
    end
  end

  @doc "Converte temperatura de Fahrenheit para Celsius."
  def to_celsius(value) when is_number(value), do: {:ok, (value - 32) * 5 / 9}

  def to_celsius(value) when is_binary(value) do
    with {:ok, num} <- to_number(value), do: to_celsius(num)
  end

  @doc "Converte pressao de inHg para hPa."
  def inhg_to_hpa(value) when is_number(value), do: {:ok, value * 33.8639}

  def inhg_to_hpa(value) when is_binary(value) do
    with {:ok, num} <- to_number(value), do: inhg_to_hpa(num)
  end

  @doc "Converte velocidade de mph para km/h."
  def mph_to_kmh(value) when is_number(value), do: {:ok, value * 1.60934}

  def mph_to_kmh(value) when is_binary(value) do
    with {:ok, num} <- to_number(value), do: mph_to_kmh(num)
  end

  @doc "Converte graus para direcao cardinal."
  def degrees_to_cardinal(value) when is_number(value) do
    degrees = normalize_degrees(value)

    cardinal =
      cond do
        degrees < 11.25 -> "N"
        degrees < 33.75 -> "NNE"
        degrees < 56.25 -> "NE"
        degrees < 78.75 -> "ENE"
        degrees < 101.25 -> "L"
        degrees < 123.75 -> "ESE"
        degrees < 146.25 -> "SE"
        degrees < 168.75 -> "SSE"
        degrees < 191.25 -> "S"
        degrees < 213.75 -> "SSO"
        degrees < 236.25 -> "SO"
        degrees < 258.75 -> "OSO"
        degrees < 281.25 -> "O"
        degrees < 303.75 -> "ONO"
        degrees < 326.25 -> "NO"
        degrees < 348.75 -> "NNO"
        true -> "N"
      end

    {:ok, cardinal}
  end

  def degrees_to_cardinal(value) when is_binary(value) do
    with {:ok, num} <- to_number(value), do: degrees_to_cardinal(num)
  end

  defp normalize_degrees(deg) when is_integer(deg) do
    deg = rem(deg, 360)
    if deg < 0, do: deg + 360, else: deg
  end

  defp normalize_degrees(deg) when is_float(deg) do
    deg = deg - Float.floor(deg / 360) * 360
    if deg < 0, do: deg + 360, else: deg
  end

  defp normalize_degrees(deg), do: deg
  defp parse_measured_at(value) when is_binary(value) do
    case Integer.parse(value) do
      {unix, _} -> parse_measured_at(unix)
      :error -> {:error, {:invalid_timestamp, value}}
    end
  end

  defp parse_measured_at(unix) when is_float(unix), do: parse_measured_at(round(unix))

  defp parse_measured_at(unix) when is_integer(unix) do
    with {:ok, dt} <- DateTime.from_unix(unix), do: {:ok, DateTime.to_naive(dt)}
  end
end
