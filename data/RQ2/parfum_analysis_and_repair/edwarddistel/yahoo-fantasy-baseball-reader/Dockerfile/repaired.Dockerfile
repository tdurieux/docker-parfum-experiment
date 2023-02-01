FROM node:12.18.3-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
WORKDIR /usr/src/app && rm -rf /var/lib/apt/lists/*;
COPY package*.json ./
COPY . .
RUN npm install && npm cache clean --force;
CMD [ "node", "src/index.js" ]