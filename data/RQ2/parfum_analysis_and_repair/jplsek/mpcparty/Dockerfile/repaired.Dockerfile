FROM node:14

RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

COPY . /app

WORKDIR /app

RUN yarn install && yarn cache clean;

ENV MPD_LIBRARY /music

ENTRYPOINT ["yarn", "start"]
