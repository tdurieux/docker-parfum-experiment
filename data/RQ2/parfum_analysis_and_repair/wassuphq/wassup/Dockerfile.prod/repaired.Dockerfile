FROM elixir:1.9.2-alpine as build

# install build dependencies
RUN apk add --no-cache --update git build-base nodejs npm yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

# build assets
COPY assets assets
COPY priv priv
RUN cd assets && npm install && npm run deploy && npm cache clean --force;
RUN mix phx.digest

# build project
COPY lib lib
RUN mix compile

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix release --overwrite

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache --update bash openssl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/wassup_app ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

# set runtime ENV; for details check '.env.example'
ENV MIX_ENV prod
ENV APP_NAME $APP_NAME
ENV APP_URL $APP_URL
ENV APP_HOSTNAME $APP_HOSTNAME
ENV PORT $PORT
ENV MAIL_SENDER_EMAIL $MAIL_SENDER_EMAIL
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV DATABASE_URL $DATABASE_URL
ENV POOL_SIZE $POOL_SIZE
ENV GOOGLE_CLIENT_ID $GOOGLE_CLIENT_ID
ENV GOOGLE_CLIENT_SECRET $GOOGLE_CLIENT_SECRET
ENV GOOGLE_REDIRECT_URI $GOOGLE_REDIRECT_URI
ENV REGISTRATION_DISABLED $REGISTRATION_DISABLED
ENV SMTP_PROVIDER_DOMAIN $SMTP_PROVIDER_DOMAIN
ENV SMTP_USERNAME $SMTP_USERNAME
ENV SMTP_PASSWORD $SMTP_PASSWORD
ENV GOOGLE_ANALYTICS_TRACKING_ID $GOOGLE_ANALYTICS_TRACKING_ID

EXPOSE $PORT

# Start the containers using:
#
#   docker run --rm -d --name wassup_app -p 80:4000 \
#     -e SECRET_KEY_BASE=XXXX \
#     -e DATABASE_URL=XXXXX \
#     wassuphq/wassup:latest \
#     bin/wassup_app start
