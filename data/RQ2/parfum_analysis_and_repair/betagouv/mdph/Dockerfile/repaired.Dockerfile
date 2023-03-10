FROM node:6

RUN mkdir -p /srv/apps

EXPOSE 9000

ADD package.json /srv/apps

WORKDIR /srv/apps

RUN npm install && npm cache clean --force;

ADD ./ /srv/apps

RUN npm run build

CMD npm start
