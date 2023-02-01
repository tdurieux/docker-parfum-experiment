FROM node:boron
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
CMD [ "npm", "test" ]