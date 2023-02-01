FROM node:8

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm install forever -g && npm cache clean --force;

EXPOSE 3100

CMD [ "forever", "app.js" ]
