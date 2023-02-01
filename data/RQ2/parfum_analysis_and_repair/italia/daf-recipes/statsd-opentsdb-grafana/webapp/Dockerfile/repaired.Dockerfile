FROM node:8.6.0

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

#COPY package.json /usr/src/app/
COPY . /usr/src/app
RUN npm install && npm cache clean --force;

CMD [ "npm", "start" ]
