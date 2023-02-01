FROM node

WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app

EXPOSE 3000
CMD [ "npm", "start" ]
