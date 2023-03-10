FROM node:14.15
WORKDIR /app

COPY ./package.json .
COPY ./yarn.lock .
COPY ./lerna.json .

RUN yarn install && yarn cache clean;
COPY . /app

RUN npm i -g lerna && npm cache clean --force;
RUN lerna bootstrap


RUN lerna run build
RUN yarn global add serve

EXPOSE 4500
CMD ["serve", "-l", "4500", "-s", "packages\admin-app\build"]

