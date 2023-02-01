# Build #
FROM node:15-buster as build
WORKDIR /usr/app

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY src ./src/

# Final Image #
FROM alpine
WORKDIR /usr/app

RUN apk add --no-cache nodejs npm
COPY --from=build /usr/app ./

ENTRYPOINT ["node", "src"]
