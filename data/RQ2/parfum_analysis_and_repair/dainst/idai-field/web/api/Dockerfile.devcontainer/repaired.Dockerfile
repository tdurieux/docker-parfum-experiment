FROM elixir:latest
# currently (September 2020) this comes with imagemagick 6.9, including delegates jp2, jpeg, png

COPY . /opt/src/api

WORKDIR "/opt/src/api"

RUN ["mix", "local.hex", "--force"]
RUN ["mix", "local.rebar", "--force"]
RUN ["mix", "deps.get"]
RUN ["mix", "deps.compile"]