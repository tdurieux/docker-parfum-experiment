FROM elixir:1.12
ENV DEBIAN_FRONTEND=noninteractive

RUN mix local.hex --force
RUN mix local.rebar --force

RUN apt-get update && apt-get install --no-install-recommends -y -q inotify-tools curl software-properties-common && curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && apt install --no-install-recommends -y nodejs && node -v && npm -v && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/local/runhyve/webapp
WORKDIR /usr/local/runhyve/webapp
