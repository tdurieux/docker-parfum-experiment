FROM node
MAINTAINER Lucas Tonetto Firmo @ DP6
ENV PORT=3000
COPY . /var/www/adinfo
WORKDIR /var/www/adinfo
RUN npm install && npm cache clean --force;
RUN npm test
ENTRYPOINT npm start
EXPOSE $PORT