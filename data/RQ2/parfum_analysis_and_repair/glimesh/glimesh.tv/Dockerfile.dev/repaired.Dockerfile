FROM elixir:1.13.4

# Install package dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential postgresql-client inotify-tools imagemagick-6.q16 librsvg2-bin && rm -rf /var/lib/apt/lists/*;

# install hex + rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# install node
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g svgo && npm cache clean --force;

# prepare build dir
WORKDIR /app
EXPOSE 4000 4001
