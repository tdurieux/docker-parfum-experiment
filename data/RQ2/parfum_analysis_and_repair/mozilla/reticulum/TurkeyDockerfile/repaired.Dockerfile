FROM elixir:1.8-alpine as builder
RUN apk add --no-cache nodejs yarn git build-base
copy . .
RUN mix local.hex --force && mix local.rebar --force && mix deps.get
run mix deps.clean mime --build && rm -rf _build && mix compile
run MIX_ENV=turkey mix distillery.release

from alpine/openssl as certr
workdir certs
run openssl req -x509 -newkey rsa:2048 -sha256 -days 36500 -nodes -keyout key.pem -out cert.pem -subj '/CN=ret' && cp cert.pem cacert.pem

FROM alpine
run mkdir -p /storage && chmod 777 /storage
workdir ret
copy --from=builder /_build/turkey/rel/ret/ .
copy --from=certr /certs .
RUN apk update && apk add --no-cache bash openssl-dev openssl jq libstdc++ coreutils
copy scripts/docker/run.sh /run.sh
cmd bash /run.sh