# Build stage: Install yarn dependencies
# ===
FROM node:16 AS yarn-dependencies

WORKDIR /srv

ADD package.json yarn.lock .
RUN --mount=type=cache,target=/usr/local/share/.cache/yarn yarn install && yarn cache clean;


# Build stage: Run "yarn run build-js"
# ===
FROM yarn-dependencies AS build-js
ADD . .
RUN yarn run build


FROM ubuntu:focal

RUN apt update && apt install --no-install-recommends --yes nginx && rm -rf /var/lib/apt/lists/*;

WORKDIR /srv

COPY nginx.conf /etc/nginx/sites-available/default
COPY entrypoint entrypoint
COPY --from=build-js /srv/build .

ENTRYPOINT ["./entrypoint"]
