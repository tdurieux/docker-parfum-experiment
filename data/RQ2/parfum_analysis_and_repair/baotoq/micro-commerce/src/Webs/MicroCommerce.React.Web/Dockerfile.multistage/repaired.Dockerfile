# Stage 1: Building the code
FROM mhart/alpine-node AS builder

EXPOSE 3000

WORKDIR /app

COPY yarn.lock ./
COPY package*.json ./

RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .

RUN yarn build

# Stage 2: And then copy over node_modules, etc from that stage to the smaller base image
FROM mhart/alpine-node:slim as production

WORKDIR /app

# COPY package.json next.config.js .env* ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

CMD ["node_modules/.bin/next", "start"]
