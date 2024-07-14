FROM elixir:latest

# Download Chromium (needed for the crawling process)
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    chromium
    
# Create and set home directory
WORKDIR /opt/weather_app

# Configure required environment
ENV MIX_ENV prod

# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all dependencies files
COPY mix.* ./

# Install all production dependencies
RUN mix deps.get --only prod

# Compile all dependencies
RUN mix deps.compile

# Copy all application files
COPY . .

# Compile the entire project
RUN mix compile

EXPOSE 4000

# Run the application itself
CMD mix phx.server
