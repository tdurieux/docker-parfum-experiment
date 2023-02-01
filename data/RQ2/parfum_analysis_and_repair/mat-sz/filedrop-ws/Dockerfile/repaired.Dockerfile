FROM node:18-alpine as build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY . /app

RUN yarn install && yarn cache clean;
RUN yarn build

EXPOSE 5000
ENV WS_HOST 0.0.0.0
CMD ["yarn", "start"]
