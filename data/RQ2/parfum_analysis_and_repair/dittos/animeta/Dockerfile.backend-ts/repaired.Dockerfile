FROM node:16 AS builder

WORKDIR /src
COPY tooling/package*.json ./
RUN npm install && npm cache clean --force;
COPY tooling .
RUN npm run build


FROM node:16

RUN apt-get update && apt-get install -y --no-install-recommends \
		imagemagick \
		jpegoptim \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app/backend-ts
COPY backend-ts/patches ./patches
COPY backend-ts/package*.json ./
COPY web/shared ../web/shared
COPY --from=builder /src ../tooling
RUN npm install && npm cache clean --force;

COPY backend-ts .
RUN node_modules/.bin/nest build

ENTRYPOINT ["node", "dist/backend-ts/src/main.js"]
