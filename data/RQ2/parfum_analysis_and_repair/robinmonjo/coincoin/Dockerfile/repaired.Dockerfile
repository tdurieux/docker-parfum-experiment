FROM elixir:1.6.1-alpine

RUN apk update && apk add --no-cache bash make git

ADD . /app
WORKDIR /app
RUN make release
CMD _build/prod/rel/coincoin/bin/coincoin console
