FROM node:17-slim

RUN apt-get update \
  && apt-get install --no-install-recommends -y sox libsox-fmt-mp3 && rm -rf /var/lib/apt/lists/*;

# libsox-fml-all instala todos os codecs

WORKDIR /spotify-radio/

COPY package.json package-lock.json /spotify-radio/

RUN npm ci --silent

COPY . .

USER node

CMD npm run live-reload