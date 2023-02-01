FROM elixir:1.4.2

ENV NODE_VERSION=7

# Install system dependencies and nodejs, then clean up apt temporary artefacts
RUN curl -f -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get -y --no-install-recommends install nodejs inotify-tools postgresql-client \
    && apt-get -y clean \
    && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

# Install Hex and Rebar
RUN mix local.hex --force \
    && mix local.rebar --force

RUN mkdir /myapp
WORKDIR /myapp

CMD iex
