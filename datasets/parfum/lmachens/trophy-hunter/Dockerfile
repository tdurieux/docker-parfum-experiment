FROM node:alpine AS deps
RUN apk add --no-cache libc6-compat git

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm set-script prepare ""
RUN npm ci

FROM node:alpine AS builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules
RUN npm run server:build
RUN npm set-script prepare ""
RUN npm ci --production --prefer-offline

FROM node:alpine AS runner
WORKDIR /app

ENV NODE_ENV production
COPY --from=builder /app/dist/server ./dist/server
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3001
CMD ["npm", "start"]