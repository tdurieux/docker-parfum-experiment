ARG ELIXIR_VERSION=1.8.1
FROM bitwalker/alpine-elixir:${ELIXIR_VERSION} as deps
ADD . /build
WORKDIR /build
RUN mix deps.clean --all && mix deps.get

FROM node:8.11.3 as assets
RUN mkdir -p /priv/static
WORKDIR /build
COPY apps/nerves_hub_www/assets apps/nerves_hub_www/assets
COPY --from=deps /build/deps deps
RUN cd apps/nerves_hub_www/assets \
  && yarn install \
  && yarn run deploy

# Elixir build container
FROM bitwalker/alpine-elixir:${ELIXIR_VERSION} as builder

ENV MIX_ENV=prod

RUN apk --no-cache add make gcc musl-dev
RUN mix local.hex --force && mix local.rebar --force
RUN mkdir /build
ADD . /build
WORKDIR /build
COPY --from=deps /build/deps deps
COPY --from=assets /build/apps/nerves_hub_www/priv/static apps/nerves_hub_www/priv/static

RUN mix do phx.digest, release --env=$MIX_ENV --name=nerves_hub_www

# Release Container
FROM nerveshub/runtime:alpine-3.9 as release

RUN apk add 'fwup~=1.3.1' \
  --repository http://nl.alpinelinux.org/alpine/edge/community/ \
  --no-cache

EXPOSE 80
EXPOSE 443

ENV LOCAL_IPV4=127.0.0.1

COPY --from=builder /build/_build/$MIX_ENV/rel/nerves_hub_www/releases/*/nerves_hub_www.tar.gz .
RUN tar xvfz nerves_hub_www.tar.gz > /dev/null && rm nerves_hub_www.tar.gz

COPY --from=builder /build/rel/scripts/docker-entrypoint.sh .
COPY --from=builder /build/rel/scripts/s3-sync.sh .
COPY --from=builder /build/rel/scripts/ecs-cluster.sh .

RUN ["chmod", "+x", "/app/docker-entrypoint.sh"]
RUN ["chmod", "+x", "/app/s3-sync.sh"]
RUN ["chmod", "+x", "/app/ecs-cluster.sh"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD ["/app/ecs-cluster.sh"]
