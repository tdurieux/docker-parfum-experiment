# ---- Base Node ----
FROM node:carbon AS base
# Create app directory
WORKDIR /app

# ---- Dependencies ----
FROM base AS dependencies
COPY package*.json ./
COPY yarn.lock ./
COPY preact.config.js ./
RUN yarn install && yarn cache clean;

# ---- Copy Files/Build ----
FROM dependencies AS build
WORKDIR /app
COPY src /app/src
RUN yarn build && yarn cache clean;
RUN yarn install --modules-folder /app/deps --production=true && yarn cache clean;

# --- Release with Alpine ----
FROM node:8.9-alpine AS release
WORKDIR /app

# install new ffmpeg version using edge repositories
RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories
RUN apk del --purge alpine-baselayout; apk --update --no-cache add alpine-baselayout busybox; apk upgrade --purge
RUN apk --update --no-cache add ffmpeg

COPY --from=build /app/build ./build
COPY --from=build /app/deps ./node_modules

VOLUME /data /incoming

CMD ["node", "build/transcode.js", "/incoming", "/data"]
