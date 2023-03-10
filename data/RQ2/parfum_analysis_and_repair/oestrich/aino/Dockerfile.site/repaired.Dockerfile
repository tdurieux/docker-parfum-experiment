FROM hexpm/elixir:1.12.2-erlang-24.0.5-alpine-3.14.0 as builder

RUN apk add --no-cache alpine-sdk
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app
ENV MIX_ENV=dev
COPY mix.* /app/
RUN mix deps.get --only dev
RUN mix deps.compile
COPY . /app/
RUN mix compile
RUN mix docs

FROM nginx:1.21.3 as web
COPY --from=builder /app/doc /usr/share/nginx/html