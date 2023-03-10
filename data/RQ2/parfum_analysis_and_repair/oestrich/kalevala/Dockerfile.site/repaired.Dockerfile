FROM hexpm/elixir:1.11.2-erlang-23.1.2-alpine-3.12.1 as builder

RUN apk add --no-cache gcc git make musl-dev
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app
ENV MIX_ENV=dev
COPY mix.* /app/
RUN mix deps.get --only dev
RUN mix deps.compile
COPY . /app/
RUN mix compile
RUN mix docs

FROM nginx:1.17.8 as web
COPY --from=builder /app/doc /usr/share/nginx/html
COPY --from=builder /app/kalevala.png /usr/share/nginx/html