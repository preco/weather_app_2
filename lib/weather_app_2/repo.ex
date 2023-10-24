defmodule WeatherApp2.Repo do
  use Ecto.Repo,
    otp_app: :weather_app_2,
    adapter: Ecto.Adapters.Postgres
end
