FROM node:16.15
WORKDIR /home/src/electricitymap/contrib/web

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y jq unzip && rm -rf /var/lib/apt/lists/*;
ADD web/package.json ./package.json
ADD web/yarn.lock ./yarn.lock
RUN yarn install --frozen-lockfile && yarn cache clean;


ADD web/src/world.json ./src/world.json
ARG ELECTRICITYMAP_PUBLIC_TOKEN

# Build
# (note: this will override the world.json that was previously created)
ADD config /home/src/electricitymap/contrib/config
ADD web ./
RUN yarn build-release && yarn cache clean;

EXPOSE 8000
ENV PORT 8000
CMD node server.js

HEALTHCHECK CMD curl --fail http://localhost:${PORT}/ || exit 1
