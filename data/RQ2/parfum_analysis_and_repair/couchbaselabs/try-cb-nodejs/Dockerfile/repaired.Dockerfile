FROM node:16-buster-slim

LABEL maintainer="Couchbase"

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential python \
    jq curl && rm -rf /var/lib/apt/lists/*;

COPY . /app

RUN npm install && npm cache clean --force;

EXPOSE 8080

ENTRYPOINT ["./wait-for-couchbase.sh", "node", "index.js"]
