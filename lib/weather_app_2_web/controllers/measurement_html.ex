defmodule WeatherApp2Web.MeasurementHTML do
  use WeatherApp2Web, :html

  embed_templates "measurement_html/*"

  @doc """
  Renders a measurement form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def measurement_form(assigns)
end
