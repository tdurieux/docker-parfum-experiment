FROM elixir:1.7.3

  RUN mix local.hex --force \
    && mix archive.install hex phx_new 1.4.0 --force \
    && apt-get update \
    && curl -f -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y nodejs \
    && apt-get install --no-install-recommends -y build-essential \
    && apt-get install --no-install-recommends -y inotify-tools \
    && mix local.rebar --force \
    && wget "https://github.com/elm/compiler/releases/download/0.19.0/binaries-for-linux.tar.gz" \
    && tar xzf binaries-for-linux.tar.gz \
    && mv elm /usr/local/bin/ && rm binaries-for-linux.tar.gz && rm -rf /var/lib/apt/lists/*;

  ENV APP_HOME /app
  WORKDIR $APP_HOME


CMD ["mix", "phx.server"]
