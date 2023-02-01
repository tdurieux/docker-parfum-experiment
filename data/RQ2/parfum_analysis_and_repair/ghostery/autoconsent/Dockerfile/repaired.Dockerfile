FROM node:12

RUN apt update && apt install --no-install-recommends -y brotli jq && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app/ && chown -R node:node /app
USER node
COPY package.json /app/
COPY package-lock.json /app/
WORKDIR /app/
RUN npm ci
