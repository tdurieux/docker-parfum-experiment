FROM node:16-slim

RUN apt update && apt install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY package.json ./
COPY index.js ./
COPY util.js ./
RUN npm install && npm cache clean --force;

RUN chown -R node:node /app
USER node

EXPOSE 3000
CMD ["node", "index.js"]
