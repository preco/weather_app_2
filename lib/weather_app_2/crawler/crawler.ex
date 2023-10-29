defmodule WeatherApp2.Crawler do
  @moduledoc  """
  Módulo responsável por obter os valores das medições,
  convertê-los para o formato do banco de dados e
  salvá-los.
  """
  @moduledoc since: "1.0.0"

  require Logger

  @doc """
  Função responsável por acessar o site
  """
  def get_url_info() do
    Logger.info("Iniciando crawler")
    url = "https://plantaragronomia.eng.br/climatologia-agricola"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        handle_table_info(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info "Not found"
      {_, %HTTPoison.Response{status_code: 500}} ->
        get_url_info()
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp handle_table_info(body) do
    body
    |> get_table_info
    |> IO.inspect
    #|> save
  end

  defp save(measurement) do
    WeatherApp2.Repo.insert("Measurements", measurement)
  end

  defp get_table_info(body) do
    body
      |> Floki.parse_document
      |> IO.inspect
      |> Floki.find("#clima-data-wrp")
      |> IO.inspect
      |> Floki.find("table")
      |> IO.inspect
      |> Floki.find("tr")
      |> IO.inspect
      |> Enum.reduce(Map.new, fn(column, attr_map) ->
        {_, [_],
        [{_,_, [attr_name]},
        {_, _, [attr_value]}]
        } = column
        converted_name = convert_name(attr_name)
        Map.put(attr_map, converted_name, convert_value(converted_name, attr_value))
      end)
  end

  defp convert_name(name) do
    name
    |> normalize_string
    |> WeatherApp2.Data.Measurement.convert_name
  end

  defp convert_value(name, value) do
    value
    |> normalize_value
    |> WeatherApp2.Data.Measurement.convert_value(name)
  end

  defp normalize_value(value) do
    value_without_comma = value
      |> normalize_string
      |> String.replace(",", ".")
    Regex.replace(~r/[^0-9.NSEO]+/, value_without_comma, "")
  end

  defp normalize_string(raw) do
    codepoints = String.codepoints(raw)
    Enum.reduce(codepoints,
      fn(w, result) ->
        cond do
          String.valid?(w) ->
            result <> w
          true ->
            << parsed :: 8>> = w
            result <>   << parsed :: utf8 >>
        end
      end)
      |> String.trim
  end
end
