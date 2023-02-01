FROM node:alpine
RUN npm install -g http-server && npm cache clean --force;
VOLUME /var/www
ENTRYPOINT ["http-server", "/var/www", "--cors", "-c-1"]

