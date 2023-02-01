ARG ELIXIR_VERSION=1.8.1
# Elixir build container
FROM bitwalker/alpine-elixir:${ELIXIR_VERSION} as builder

ENV MIX_ENV=prod

RUN apk --no-cache add make gcc musl-dev
RUN mix local.hex --force && mix local.rebar --force
RUN mkdir /build
ADD . /build
WORKDIR /build

RUN mix deps.clean --all && mix deps.get
RUN mix release --env=$MIX_ENV --name=nerves_hub_device

# Release Container
FROM nerveshub/runtime:alpine-3.9 as release

EXPOSE 443

WORKDIR /app

COPY --from=builder /build/_build/$MIX_ENV/rel/nerves_hub_device/releases/*/nerves_hub_device.tar.gz .
RUN tar xvfz nerves_hub_device.tar.gz > /dev/null && rm nerves_hub_device.tar.gz

COPY --from=builder /build/rel/scripts/docker-entrypoint.sh .
COPY --from=builder /build/rel/scripts/s3-sync.sh .
COPY --from=builder /build/rel/scripts/ecs-cluster.sh .

RUN ["chmod", "+x", "/app/docker-entrypoint.sh"]
RUN ["chmod", "+x", "/app/s3-sync.sh"]
RUN ["chmod", "+x", "/app/ecs-cluster.sh"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD ["/app/ecs-cluster.sh"]
