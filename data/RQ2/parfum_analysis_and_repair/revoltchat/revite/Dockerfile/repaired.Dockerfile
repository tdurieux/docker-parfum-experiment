FROM node:16-buster AS builder

WORKDIR /usr/src/app
COPY . .
COPY .env.build .env

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn typecheck
RUN yarn build:highmem
RUN yarn workspaces focus --production --all && yarn cache clean;

FROM node:16-alpine
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .

EXPOSE 5000
CMD [ "yarn", "start:inject" ]
