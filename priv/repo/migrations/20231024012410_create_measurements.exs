defmodule WeatherApp2.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:measurements) do
      add :temperature, :float
      add :humidity, :float
      add :atmospheric_pressure, :float
      add :wind_speed, :float
      add :wind_direction, :string
      add :river_level, :float

      timestamps()
    end
  end
end
