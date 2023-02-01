FROM node:latest
ARG version
EXPOSE 80

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY $version/package.json /usr/src/app
RUN npm install && npm cache clean --force;
COPY $version/ /usr/src/app

CMD ["npm", "start"]
