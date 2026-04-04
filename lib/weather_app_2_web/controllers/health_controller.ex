defmodule WeatherApp2Web.HealthController do
  use WeatherApp2Web, :controller

  @doc """
  Healthcheck endpoint. Retorna status 200 com informações básicas da aplicação.
  Usado pelo Gigalixir e load balancers para verificar disponibilidade.
  """
  def index(conn, _params) do
    status = %{
      status: "ok",
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      app: Application.get_env(:weather_app_2, :app_name, "weather_app_2"),
      version: Application.spec(:weather_app_2, :vsn) |> to_string()
    }

    json(conn, status)
  end
end