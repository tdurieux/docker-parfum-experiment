FROM node:14.10.1
WORKDIR KonataBot
COPY package.json *
COPY . .
RUN npm install && npm cache clean --force;
RUN ["node", "src/Konata.js"]
