## Build layer
FROM node:16.0.0 AS builder
WORKDIR /app
COPY package*.json .
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

## Production layer
FROM alpine
WORKDIR /app
COPY --from=builder /app/package*.json .
COPY --from=builder /app/build build
COPY --from=builder /app/server server
RUN apk add --no-cache --update nodejs npm
RUN npm install --only=prod && npm cache clean --force;
RUN addgroup -S app && adduser -S prod -G app
USER prod
CMD ["npm", "run", "serve"]
