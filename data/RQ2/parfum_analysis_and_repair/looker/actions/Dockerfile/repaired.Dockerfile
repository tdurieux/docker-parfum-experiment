FROM node:14.18.0

RUN mkdir -p /code
WORKDIR /code

COPY . /code

RUN yarn install --production && yarn cache clean && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD ["yarn","start"]

EXPOSE 8080
