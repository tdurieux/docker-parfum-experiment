FROM node:boron-alpine
MAINTAINER Mario Behling <mb@mariobehling.de>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# copy requirements
COPY package.json /usr/src/app/
COPY electron-builder.json /usr/src/app/

# install requirements
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

EXPOSE 4200

CMD [ "npm", "start" ]

