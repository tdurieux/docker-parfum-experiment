FROM node:16-slim

RUN apt update -y && apt-get install --no-install-recommends build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev -y && rm -rf /var/lib/apt/lists/*;

COPY . /app
WORKDIR /app

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD ["yarn", "start"]