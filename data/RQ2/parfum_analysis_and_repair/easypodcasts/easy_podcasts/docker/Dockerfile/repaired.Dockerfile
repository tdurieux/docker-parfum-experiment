# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
  apt-get install --no-install-recommends -y postgresql-client inotify-tools ffmpeg && rm -rf /var/lib/apt/lists/*;

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
EXPOSE 4000
