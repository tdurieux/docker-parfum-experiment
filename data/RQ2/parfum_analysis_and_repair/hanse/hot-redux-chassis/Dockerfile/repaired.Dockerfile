# Stage 1

FROM node:14-alpine as builder

WORKDIR /app

ARG UNSPLASH_APPLICATION_ID

ENV NODE_ENV production
ENV UNSPLASH_APPLICATION_ID ${UNSPLASH_APPLICATION_ID}

COPY package.json .
COPY yarn.lock .
COPY scripts ./scripts

RUN yarn --production=false && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

# Stage 2

FROM node:14-alpine
WORKDIR /app

ENV PORT 3000
ENV NODE_ENV production

COPY package.json .
COPY yarn.lock .
COPY scripts ./scripts

RUN yarn && yarn cache clean;

COPY . .

COPY --from=builder /app/dist ./dist

USER node

EXPOSE $PORT

CMD ["node", "server"]

