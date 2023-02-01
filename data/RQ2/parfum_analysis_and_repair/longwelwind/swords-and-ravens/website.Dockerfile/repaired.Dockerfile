FROM node:14 AS build-client
# Build the client of the game
WORKDIR /app

COPY ./agot-bg-game-server/package.json .
COPY ./agot-bg-game-server/yarn.lock .
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ./agot-bg-game-server/ .

ENV ASSET_PATH=https://swords-and-ravens.ams3.cdn.digitaloceanspaces.com/

RUN yarn run generate-json-schemas && yarn cache clean;
RUN yarn run build-client && yarn cache clean;

FROM python:3.8-slim

RUN apt-get update && apt-get install --no-install-recommends -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY ./agot-bg-website/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir daphne==2.4.1

# From the previous stage, copy the assets and the index.html
COPY --from=build-client /app/dist ./static_game
COPY --from=build-client /app/dist/index.html ./agotboardgame_main/templates/agotboardgame_main/play.html

COPY ./agot-bg-website .
COPY website.Procfile Procfile

RUN mkdir /django_metrics
