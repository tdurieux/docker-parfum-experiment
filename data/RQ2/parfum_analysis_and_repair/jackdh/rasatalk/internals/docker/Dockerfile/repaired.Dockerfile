FROM node:10-jessie-slim

RUN apt-get update && apt-get install --no-install-recommends libpng12-0 bzip2 -y && rm -rf /var/lib/apt/lists/*;

# Create app directory
WORKDIR /usr/src/app

COPY . .

RUN yarn install && yarn cache clean;

RUN yarn build && yarn cache clean;

CMD ["yarn", "start:prod"]
