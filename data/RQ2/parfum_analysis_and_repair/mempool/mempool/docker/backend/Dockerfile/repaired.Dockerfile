FROM node:16.16.0-buster-slim AS builder

ARG commitHash
ENV DOCKER_COMMIT_HASH=${commitHash}

WORKDIR /build
COPY . .

RUN apt-get update && apt-get install --no-install-recommends -y build-essential python3 pkg-config && rm -rf /var/lib/apt/lists/*;
RUN npm install --omit=dev --omit=optional && npm cache clean --force;
RUN npm run build

FROM node:16.16.0-buster-slim

WORKDIR /backend

COPY --from=builder /build/ .

RUN chmod +x /backend/start.sh
RUN chmod +x /backend/wait-for-it.sh

RUN chown -R 1000:1000 /backend && chmod -R 755 /backend

USER 1000

EXPOSE 8999

CMD ["/backend/start.sh"]
