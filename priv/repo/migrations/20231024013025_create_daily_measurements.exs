defmodule WeatherApp2.Repo.Migrations.CreateDailyMeasurements do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:daily_measurements) do
      add :precipitation_of_the_day, :float

      timestamps()
    end
  end
end
