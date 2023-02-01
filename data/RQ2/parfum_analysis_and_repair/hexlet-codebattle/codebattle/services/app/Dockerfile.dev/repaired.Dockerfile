FROM elixir:1.13.4

RUN mix local.hex --force \
  && mix local.rebar --force

RUN apt-get update \
  && apt-get install --no-install-recommends -y inotify-tools vim wkhtmltopdf && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get update \
  && apt-get install --no-install-recommends -y nodejs \
  && npm install --global yarn@1.22.10 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ENV DOCKER_CHANNEL edge
ENV DOCKER_VERSION 18.09.3
RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
  | tar -xzC /usr/local/bin --strip=1 docker/docker

WORKDIR /app
