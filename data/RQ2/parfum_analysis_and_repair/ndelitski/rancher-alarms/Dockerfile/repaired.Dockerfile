FROM mhart/alpine-node:4

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install --loglevel warn && npm cache clean --force;
COPY . /usr/src/app

CMD [ "npm", "start" ]
