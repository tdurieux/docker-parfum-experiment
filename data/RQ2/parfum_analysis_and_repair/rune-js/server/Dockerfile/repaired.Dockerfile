FROM node:16
WORKDIR /usr/src/app
COPY package.json ./
COPY package-lock.json ./

RUN npm install && npm cache clean --force;

COPY src ./src
COPY tsconfig.json ./

RUN npm build

EXPOSE 43594
CMD [ "npm", "start" ]
