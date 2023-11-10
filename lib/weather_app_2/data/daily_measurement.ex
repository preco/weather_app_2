defmodule WeatherApp2.Data.DailyMeasurement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_measurements" do
    field :precipitation_of_the_day, :float

    timestamps()
  end

  @doc false
  def changeset(daily_measurement, attrs) do
    daily_measurement
    |> cast(attrs, [:precipitation_of_the_day])
    |> validate_required([:precipitation_of_the_day])
  end

end
