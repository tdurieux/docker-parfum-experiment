FROM node:12-alpine
WORKDIR /app

COPY package.json yarn.lock tsconfig.json ./
RUN yarn --frozen-lockfile && yarn cache clean;

COPY src src
COPY public public

ENV NODE_ENV production

COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

EXPOSE 1729

ENTRYPOINT ["/app/docker-entrypoint.sh"]