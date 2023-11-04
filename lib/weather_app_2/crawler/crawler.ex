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
  Para executar essa função, é necessário que o Sistema Operacional
  possua o chromium Code{sudo apt install chromium-browser}
  """
  def get_url_info() do
    Logger.info("Iniciando crawler")
    command = "chromium-browser"
    args = ["--headless",
            "--disable-gpu",
            "--dump-dom https://plantaragronomia.eng.br/climatologia-agricola",
            "--virtual-time-budget=10000"]

    str = []
    {result, _} = System.shell(command <> " " <> Enum.join(args, " "), into: str)
    result = result |> Enum.reduce("", fn x, acc -> acc <> " " <> x end)
    handle_table_info(result)
  end

  defp handle_table_info(body) do
    body
    |> get_table_info
    |> remove_unused_fields
    |> WeatherApp2.Data.create_measurement
  end

  defp get_table_info(body) do
    {:ok, body} = body |> Floki.parse_document
    body
      |> Floki.find("#clima-data-wrp")
      |> Floki.find("table")
      |> Floki.find("tr")
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

  def remove_unused_fields(measurement) do
    Map.filter(measurement, fn {k, _v} -> is_atom(k) end )
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
