FROM node:14.16-alpine3.10 AS deps

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:14.16-alpine3.10 AS builder

WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules

ARG NODE_ENV=production

RUN yarn build

# Production image, copy all the files and run next
FROM node:14.16-alpine3.10 AS runner

ARG NODE_ENV=production
ENV NODE_ENV=production

WORKDIR /app

RUN addgroup -g 1001 -S nodejs
RUN adduser -S keystonejs -u 1001
USER keystonejs

COPY --from=builder --chown=keystonejs:nodejs /app/.keystone ./.keystone
COPY --from=builder --chown=keystonejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=keystonejs:nodejs /app/package.json ./package.json

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry.
# RUN npx next telemetry disable

CMD ["yarn", "start"]
