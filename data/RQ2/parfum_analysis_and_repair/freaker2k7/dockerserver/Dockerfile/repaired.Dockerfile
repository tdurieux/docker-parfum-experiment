FROM node:12

RUN curl -f -L https://get.docker.com | sh -
RUN npm i -g docker-server@1.9.0 && npm cache clean --force;

CMD ["docker-server"]