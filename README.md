# WeatherApp2

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Additional env variables

The file `priv/.env` must contain:
DATABASE_URL=ecto://user:pw@host/weather-app-2?sslmode=require
SECRET_KEY_BASE=(secret generated from `openssl rand -base64 64`)


## Deploying

Just run `docker compose up` and it should be running :)

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
