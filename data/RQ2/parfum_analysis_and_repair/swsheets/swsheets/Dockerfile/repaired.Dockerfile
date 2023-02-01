FROM bitwalker/alpine-elixir-phoenix:1.10.3

RUN apk update && \
    apk add --no-cache postgresql-client

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD assets/package.json assets/
RUN npm install -g yarn && npm cache clean --force;
RUN cd assets && \
    yarn install && yarn cache clean;

COPY . .

EXPOSE 4000

ENTRYPOINT ["./docker-entry.sh"]
