FROM node:12.16.3-stretch

COPY . /code
WORKDIR /code

RUN yarn && yarn run build && yarn cache clean;
EXPOSE 5000

CMD [ "yarn", "start" ]
