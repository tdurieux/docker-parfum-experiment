FROM node:latest
ADD . /home/context
WORKDIR /home/context
RUN npm install && npm cache clean --force;
RUN npm rebuild node-sass

ENTRYPOINT npm run develop