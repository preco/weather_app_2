defmodule WeatherApp2.Data.Measurement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "measurements" do
    field :temperature, :float
    field :humidity, :float
    field :atmospheric_pressure, :float
    field :wind_speed, :float
    field :wind_direction, :string
    field :river_level, :float
    field :measured_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [:temperature, :humidity, :atmospheric_pressure, :wind_speed, :wind_direction, :river_level, :measured_at])
    |> validate_required([:temperature, :humidity, :atmospheric_pressure, :wind_speed, :wind_direction, :river_level, :measured_at])
  end

  @doc """
  Converte os nomes das colunas da tabela do site nos respectivos
  atoms
  """
  def convert_name(name) do
    case name do
      "Temperatura" -> :temperature
      "Umidade relativa do ar" -> :humidity
      "Pressão Atmosférica" -> :atmospheric_pressure
      "Velocidade do vento" -> :wind_speed
      "Direção do vento" -> :wind_direction
      "Nível do Rio Tubarão" -> :river_level
      _ -> name
    end
  end

  @doc """
  Converte o valor para um formato aceito pelo banco de dados
  """
  def convert_value(value, attr) do
    case attr do
      :wind_direction -> value
      _ -> parse_float(value)
    end
  end

  defp parse_float(value) do
    {parsed, _} = Float.parse(value)
    parsed
  end
end
