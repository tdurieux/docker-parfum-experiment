FROM docker.artifacts.apextoaster.com/library/node:18

# install sqlite tools
RUN apt-get update \
 && apt-get install --no-install-recommends -y bash curl jq sqlite3 \
 && rm -rf /var/lib/apt/lists/*

# copy build output
COPY package.json yarn.lock /app/
COPY out/vendor.js /app/out/
COPY out/index.js out/main.js /app/out/

WORKDIR /app

# install native modules
RUN yarn install --production && yarn cache clean;

ENTRYPOINT [ "node", "/app/out/index.js" ]
