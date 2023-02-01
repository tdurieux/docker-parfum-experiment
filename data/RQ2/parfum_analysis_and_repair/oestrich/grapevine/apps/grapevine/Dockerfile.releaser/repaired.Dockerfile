FROM grapevinehaus/elixir:1.10 as builder

RUN mix local.rebar --force && \
    mix local.hex --force
WORKDIR /apps/grapevine
ENV MIX_ENV=prod
COPY data/mix.* /apps/data/
COPY socket/mix.* /apps/socket/
COPY telnet/mix.* /apps/telnet/
COPY grapevine/mix.* /apps/grapevine/
RUN mix deps.get --only prod
RUN mix deps.compile

FROM node:10.9 as frontend
WORKDIR /app
COPY grapevine/assets/package.json grapevine/assets/yarn.lock /app/
COPY --from=builder /apps/grapevine/deps/phoenix /deps/phoenix
COPY --from=builder /apps/grapevine/deps/phoenix_html /deps/phoenix_html
COPY --from=builder /apps/grapevine/deps/phoenix_live_view /deps/phoenix_live_view
RUN npm install -g yarn && yarn install && npm cache clean --force; && yarn cache clean;
COPY grapevine/assets /app
RUN yarn run deploy

FROM builder as releaser
COPY --from=frontend /priv/static /apps/grapevine/priv/static
COPY data /apps/data
COPY socket /apps/socket
COPY telnet /apps/telnet
COPY grapevine /apps/grapevine
RUN mix compile && \
  mix phx.digest && \
  mix release && \
  cd _build/prod/rel/grapevine/ && \
  tar czf /opt/grapevine.tar.gz .
