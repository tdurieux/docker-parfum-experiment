FROM node:16 AS builder
WORKDIR /build
COPY . .
RUN yarn build

FROM gcr.io/distroless/nodejs:16
COPY --from=builder /build/dist /app
COPY --from=builder /build/node_modules /app/node_modules
WORKDIR /app
CMD ["main.js"]
