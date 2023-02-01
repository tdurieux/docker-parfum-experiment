FROM node:carbon
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN npm install -g serve && npm cache clean --force;
RUN npm install && npm cache clean --force;
ARG FLOTILLA_API
ARG DEFAULT_CLUSTER
RUN npm run build
ENTRYPOINT serve -s build
