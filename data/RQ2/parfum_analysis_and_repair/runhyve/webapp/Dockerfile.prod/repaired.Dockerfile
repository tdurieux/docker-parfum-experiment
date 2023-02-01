FROM elixir:1.12
ARG SECRET_KEY_BASE

ENV DEBIAN_FRONTEND=noninteractive
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN mix local.hex --force
RUN mix local.rebar --force

RUN apt-get update && apt-get install --no-install-recommends -y -q git make inotify-tools curl software-properties-common && curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && apt install --no-install-recommends -y nodejs && node -v && npm -v && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/local/runhyve/webapp
ADD . /usr/local/runhyve/webapp
WORKDIR /usr/local/runhyve/webapp
RUN mix deps.get --only-prod
WORKDIR /usr/local/runhyve/webapp/assets
RUN npm install && npm cache clean --force;
WORKDIR /usr/local/runhyve/webapp
RUN mix compile && mix assets.deploy && mix phx.digest
