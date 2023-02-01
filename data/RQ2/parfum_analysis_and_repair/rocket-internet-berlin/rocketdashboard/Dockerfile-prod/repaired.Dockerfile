FROM node:boron-alpine
RUN mkdir -p /code
WORKDIR /code
COPY package.json .
RUN yarn && yarn cache clean;
ADD . /code
RUN yarn build && yarn cache clean;
CMD [ "yarn", "start:production" ]
EXPOSE 3000
