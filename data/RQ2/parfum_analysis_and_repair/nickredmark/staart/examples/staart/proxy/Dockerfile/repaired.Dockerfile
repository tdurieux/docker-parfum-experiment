FROM node:10

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080
ENTRYPOINT [ "npm", "run"]
CMD [ "start" ]
