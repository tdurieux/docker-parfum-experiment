FROM electronuserland/builder:wine as windows

WORKDIR /opt/src

COPY apps/desktop/package.json ./apps/desktop/
COPY apps/api/package.json ./apps/api/
COPY package.json yarn.lock ./

RUN yarn install --network-timeout 1000000 --frozen-lockfile && yarn cache clean;

COPY . .

RUN yarn bootstrap && yarn cache clean;

RUN yarn build:desktop:windows && yarn cache clean;

FROM debian:buster-slim

WORKDIR /opt/artifacts

COPY --from=windows /opt/src/dist/apps/desktop-packages ./windows/
