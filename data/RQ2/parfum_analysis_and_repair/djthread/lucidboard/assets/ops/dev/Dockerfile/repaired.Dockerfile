FROM elixir:latest

ARG QL_MODE
ENV QL_MODE=$QL_MODE

COPY setup_security.sh /
RUN /setup_security.sh

RUN apt-get update && apt-get install --no-install-recommends --yes build-essential inotify-tools postgresql-client fish vim && rm -rf /var/lib/apt/lists/*;

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /app
EXPOSE 8800

COPY config.fish /root/.config/fish/config.fish

ENTRYPOINT fish
