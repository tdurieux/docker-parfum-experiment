FROM node:12.2.0-stretch

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y imagemagick build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && rm -rf /var/lib/apt/lists/*;

COPY ./package.json .
COPY ./yarn.lock .

RUN yarn

COPY index.js .
COPY map.js .

RUN mkdir /app/public

ENTRYPOINT [ "yarn", "start" ]