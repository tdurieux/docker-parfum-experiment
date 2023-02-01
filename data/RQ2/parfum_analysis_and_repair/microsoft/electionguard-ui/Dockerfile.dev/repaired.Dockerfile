FROM node:14.15
WORKDIR /app

COPY ./package.json .
COPY ./yarn.lock .
COPY ./lerna.json .

RUN yarn install && yarn cache clean;
RUN npm i -g lerna && npm cache clean --force;
RUN lerna bootstrap

RUN lerna run build

EXPOSE 3001
CMD ["lerna", "run", "start"]
