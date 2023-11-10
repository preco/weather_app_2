defmodule WeatherApp2.Repo.Migrations.MeasurementsAddMeasuredAtColumn do
  use Ecto.Migration

  def change do
    alter table(:measurements) do
      add :measured_at, :naive_datetime, default: fragment("now()")
    end
  end
end
