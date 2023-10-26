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

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [:temperature, :humidity, :atmospheric_pressure, :wind_speed, :wind_direction, :river_level])
    |> validate_required([:temperature, :humidity, :atmospheric_pressure, :wind_speed, :wind_direction, :river_level])
  end
end
