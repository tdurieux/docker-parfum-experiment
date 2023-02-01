FROM node:16

RUN apt update && apt install --no-install-recommends -y cowsay && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY package.json ./
COPY package-lock.json ./
RUN npm install && npm cache clean --force;

COPY . .

USER node

EXPOSE 3000
CMD ["node", "src/index.js"]