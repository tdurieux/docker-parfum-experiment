FROM node:dubnium-alpine

WORKDIR /usr/src/app

# install dependencies
COPY package.json .
RUN npm install && npm cache clean --force;

# install the app
COPY . .

EXPOSE 3000
CMD [ "npm", "start" ]
