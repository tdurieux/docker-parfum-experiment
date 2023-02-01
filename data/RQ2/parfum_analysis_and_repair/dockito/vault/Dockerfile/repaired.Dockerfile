FROM mhart/alpine-node:0.10

RUN mkdir -p /vault /usr/src/app && rm -rf /vault

WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;
COPY . /usr/src/app/

EXPOSE 3000
VOLUME /vault

CMD [ "npm", "start" ]
