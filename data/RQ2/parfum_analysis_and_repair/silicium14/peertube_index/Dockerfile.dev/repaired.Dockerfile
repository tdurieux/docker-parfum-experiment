FROM elixir:1.9.1-alpine
RUN apk update && apk add --no-cache git

WORKDIR /srv
RUN mix local.rebar --force
RUN mix local.hex --force

CMD /bin/sh -c "mix deps.get && mix run --no-halt"
