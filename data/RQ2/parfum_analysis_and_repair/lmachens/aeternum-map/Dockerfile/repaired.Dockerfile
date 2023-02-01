FROM node:lts-alpine AS deps
RUN apk add --no-cache libc6-compat git

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm set-script prepare ""
RUN npm ci

FROM node:lts-alpine AS builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules
ARG VITE_API_ENDPOINT=
ARG VITE_PLAUSIBLE_API_HOST=
ARG VITE_PLAUSIBLE_DOMAIN=
RUN npm run server:build
RUN npm run client:build
RUN npm set-script prepare ""
RUN npm ci --production --prefer-offline

FROM node:lts-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3001
CMD ["npm", "start"]