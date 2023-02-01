FROM node:8.9.4
LABEL authors="John Nolette <john@neetgroup.net>"

ADD . /opt/app
WORKDIR /opt/app
RUN npm install && npm cache clean --force;

EXPOSE 8080

CMD [ "npm", "start" ]
