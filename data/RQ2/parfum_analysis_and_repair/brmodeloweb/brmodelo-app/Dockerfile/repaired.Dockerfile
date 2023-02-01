FROM node:16
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN yarn install && yarn cache clean;
COPY . /usr/src/app
EXPOSE 9000
CMD [ "yarn", "start:frontend", "yarn" , "start:dev" ]