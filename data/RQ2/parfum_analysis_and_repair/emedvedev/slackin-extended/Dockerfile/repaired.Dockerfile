FROM node:16-alpine
ADD . /srv/www
WORKDIR /srv/www
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm run build

CMD ./bin/slackin.js
