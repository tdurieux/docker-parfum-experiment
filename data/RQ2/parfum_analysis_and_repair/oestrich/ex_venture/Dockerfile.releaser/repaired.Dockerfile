FROM hexpm/elixir:1.11.1-erlang-23.1.1-ubuntu-groovy-20201022.1 as builder

RUN apt install --no-install-recommends -y git build-essential && rm -rf /var/lib/apt/lists/*;
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod
COPY mix.* /app/
RUN mix deps.get --only prod
RUN mix deps.compile

FROM node:12.18 as frontend
WORKDIR /app
COPY assets/package.json assets/yarn.lock /app/
COPY --from=builder /app/deps/phoenix /deps/phoenix
COPY --from=builder /app/deps/phoenix_html /deps/phoenix_html
RUN yarn install && yarn cache clean;
COPY assets /app
RUN yarn run deploy:js && \
  yarn run deploy:css && \
  yarn run deploy:static

FROM builder as releaser
COPY --from=frontend /priv/static /app/priv/static
COPY . /app/
RUN mix phx.digest
RUN mix release && \
  cd _build/prod/rel/ex_venture/ && \
  tar czf /opt/ex_venture.tar.gz .
