defmodule WeatherApp2Web.DailyMeasurementHTML do
  use WeatherApp2Web, :html

  embed_templates "daily_measurement_html/*"

  @doc """
  Renders a daily_measurement form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def daily_measurement_form(assigns)
end
