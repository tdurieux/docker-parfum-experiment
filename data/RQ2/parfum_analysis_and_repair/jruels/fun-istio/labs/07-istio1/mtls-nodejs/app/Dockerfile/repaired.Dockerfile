FROM node:lts-slim
WORKDIR '/usr/app/test'
COPY package.json .
RUN npm install && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends curl jq -y && rm -rf /var/lib/apt/lists/*;
COPY . .
EXPOSE 8001
CMD ["node","index.js"]
