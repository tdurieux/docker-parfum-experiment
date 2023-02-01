FROM node:17.6

RUN apt-get update && apt-get install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;

RUN groupadd appgroup && useradd -g appgroup appuser

COPY ./ ./

EXPOSE 9999

USER appuser

CMD ["node", "server.js"]
