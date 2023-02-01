FROM ghcr.io/lolopinto/ent:0.0.30-nodejs-16-dev

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends build-essential -yqq && rm -rf /var/lib/apt/lists/*;

COPY . .

CMD ["node", "dist/graphql/index.js"]
