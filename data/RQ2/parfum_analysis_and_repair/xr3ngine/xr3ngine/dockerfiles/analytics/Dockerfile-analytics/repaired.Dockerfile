# not slim because we need github depedencies
FROM root-builder as builder

# Create app directory
WORKDIR /app

# to make use of caching, copy only package files and install dependencies
COPY packages/analytics/package.json ./packages/analytics/

ARG NODE_ENV
RUN npm install --loglevel notice --legacy-peer-deps && npm cache clean --force;

COPY . .

# copy then compile the code

ENV APP_ENV=production

FROM node:16-buster-slim as runner
WORKDIR /app

COPY --from=builder /app ./

CMD ["scripts/start-server.sh"]
