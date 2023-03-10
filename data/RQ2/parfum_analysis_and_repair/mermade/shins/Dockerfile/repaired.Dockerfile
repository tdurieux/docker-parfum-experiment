FROM node:dubnium-alpine

WORKDIR /srv/shins

# install dependencies
COPY package.json .
RUN npm install && npm cache clean --force;

# install the app
COPY . .

VOLUME /srv/shins/source

EXPOSE 4567
CMD [ "npm", "run", "serve" ]
