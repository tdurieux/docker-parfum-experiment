FROM node:10

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

ENTRYPOINT [ "npm", "run"]
CMD [ "start" ]
