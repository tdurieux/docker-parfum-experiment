FROM santimentjenkins/elixir:1.12

RUN apk add --no-cache make \
                       g++ \
                       git \
                       postgresql-client \
                       nodejs \
                       nodejs-npm \
                       inotify-tools \
                       imagemagick \
                       openssl \
                       wget \
                       rust \
                       cargo

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.5.3

#RUN mix format --check-formatted

WORKDIR /app