FROM node:17-slim

RUN apt-get update && \
 apt-get install --no-install-recommends -y sox libsox-fmt-mp3 && rm -rf /var/lib/apt/lists/*;
# libsox-fmt-all: to all audio formats

WORKDIR /spotify-radio/

COPY package*.json ./

RUN npm ci --silent

COPY . .

USER node

CMD npm run dev