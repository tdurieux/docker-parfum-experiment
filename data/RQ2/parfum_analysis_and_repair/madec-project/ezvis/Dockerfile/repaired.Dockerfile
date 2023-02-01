FROM node:4.4.0

# need jq to parse JSON
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY ./package.json /app
RUN npm install --production && npm cache clean --force;

# add few dataset to have something to play with
RUN mkdir -p /app/example/data
ADD https://raw.githubusercontent.com/madec-project/showcase/master/demo_films/repository/films.csv \
    /app/example/data/films.csv
ADD https://raw.githubusercontent.com/madec-project/showcase/master/demo_films/repository.json \
    /app/example/data.json
RUN chmod 777 /app/example/data/films.csv /app/example/data.json

RUN jq '.MONGO_HOST_PORT = "mongo-db:27017"' /app/example/data.json > /tmp/data.json \
    && cat /tmp/data.json > /app/example/data.json

# ezmasterization of ezvis
# see https://github.com/Inist-CNRS/ezmaster
RUN echo '{ \
  "httpPort": 3000, \
  "configPath": "/app/example/data.json", \
  "dataPath":   "/app/example/data/" \
}' > /etc/ezmaster.json

COPY . /app

ENTRYPOINT ./docker-entrypoint.sh
EXPOSE 3000