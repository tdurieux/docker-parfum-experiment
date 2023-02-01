FROM node:16.15-buster-slim AS builder

RUN apt-get update && apt-get install --no-install-recommends -y git python3 build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /build
COPY . .
RUN npm ci
RUN npm run build
WORKDIR /build/oracle-server-ui
RUN npm run build
WORKDIR /build/oracle-server-ui-proxy
RUN npm run build

FROM node:16.15-buster-slim
USER 1000
WORKDIR /build
COPY --from=builder /build .
EXPOSE 3001
WORKDIR oracle-server-ui-proxy
CMD ["npm", "run", "start"]
