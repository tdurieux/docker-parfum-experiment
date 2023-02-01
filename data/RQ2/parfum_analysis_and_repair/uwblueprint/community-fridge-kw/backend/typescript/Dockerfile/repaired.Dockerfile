FROM node:14.15.5-slim

WORKDIR /app

COPY package.json yarn.lock ./

# libcurl3 is required for mongodb-memory-server, which is used for testing
RUN apt-get update && apt-get install --no-install-recommends -y libcurl3 && rm -rf /var/lib/apt/lists/*;

RUN yarn install && yarn cache clean;

COPY . ./

EXPOSE 5000
ENTRYPOINT ["yarn", "dev"]
