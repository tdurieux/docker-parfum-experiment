FROM node:12.16.2-alpine3.11

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
RUN npm install -g react-scripts --silent && npm cache clean --force;

COPY package.json yarn.lock /app/
RUN yarn install && yarn cache clean;

COPY . /app

RUN CI=true yarn test && yarn cache clean;
RUN yarn build

CMD yarn start
