FROM elixir:1.10.2

ENV HOME /home/shared
ENV LANG C.UTF-8

WORKDIR /app

RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash -

RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -yqq postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm-check-updates env-cmd && npm cache clean --force;

# Install hex (Elixir package manager)
RUN mix local.hex --force
# Install rebar (Erlang build tool)
RUN mix local.rebar --force
RUN mix archive.install --force hex phx_new 1.4.16

ENV DOCKER_CHANNEL edge
ENV DOCKER_VERSION 19.03.8
RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
  | tar -xzC /usr/local/bin --strip=1 docker/docker

COPY mix.exs mix.lock ./
RUN mix deps.get
COPY config .
RUN MIX_ENV=prod mix deps.compile

COPY assets/package.json ./assets/package.json
COPY assets/package-lock.json ./assets/package-lock.json

RUN npm ci --prefix ./assets

COPY . .

RUN MIX_ENV=prod env-cmd -f .env.docker mix compile
RUN NODE_ENV=production npm run deploy --prefix ./assets
RUN MIX_ENV=prod env-cmd -f .env.docker mix phx.digest

CMD ["mix", "phx.server"]
