FROM gitpod/workspace-full

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Install Erlang, Elixir, Hex and Rebar
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install --no-install-recommends esl-erlang -y \
    && apt-get install --no-install-recommends elixir -y \
    && apt-get install --no-install-recommends inotify-tools -y \
    && mix local.hex --force \
    && mix local.rebar --force \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*