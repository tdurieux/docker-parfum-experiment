FROM node:12.2.0-alpine

ADD package.json /frontend/
ADD package-lock.json /frontend/

WORKDIR /frontend
RUN npm install && npm cache clean --force;

ENV REACT_APP_VERSION=dev-in-docker

CMD ["npm","run","start"]


