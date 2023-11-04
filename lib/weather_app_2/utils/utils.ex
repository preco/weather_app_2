defmodule WeatherApp2.Utils do

  @doc """
  Formata uma data no formato dd/mm/yyyy
  """
  def formatted_date (inserted_at) do
    IO.inspect(Tz.TimeZoneDatabase)
    inserted_at
      |> DateTime.shift_zone!("America/Sao_Paulo", Tz.TimeZoneDatabase)
      |> Calendar.strftime("%d/%m/%Y")
  end

  @doc """
  Formata uma data no formato dd/mm/yyyy
  """
  def formatted_date_time (inserted_at) do
    inserted_at
      |> DateTime.shift_zone!("America/Sao_Paulo", Tz.TimeZoneDatabase)
      |> Calendar.strftime("%d/%m/%Y %H:%M:%S")
  end
end
