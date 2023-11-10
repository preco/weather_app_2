# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :weather_app_2,
  ecto_repos: [WeatherApp2.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :weather_app_2, WeatherApp2Web.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: WeatherApp2Web.ErrorHTML, json: WeatherApp2Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: WeatherApp2.PubSub,
  live_view: [signing_salt: "xDV36eQK"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :weather_app_2, WeatherApp2.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Timezone configuration for database saving purposes
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# Scheduler configuration
config :weather_app_2, WeatherApp2.Scheduler,
  jobs: [
    # Every 30 minutes
    {"*/30 * * * *",   fn -> WeatherApp2.Crawler.get_url_info end}
  ]
