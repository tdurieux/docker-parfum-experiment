FROM node:alpine

LABEL source=git@github.com:kyma-project/examples.git

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD [ "npm", "start" ]
