FROM node:6

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/
RUN yarn && yarn cache clean;

COPY . /usr/src/app

RUN yarn build && yarn cache clean;
EXPOSE 3000

CMD [ "yarn", "start" ]
