FROM node:17
ENV DISABLE_ESLINT_PLUGIN=true
WORKDIR /usr/src/app
COPY . .

RUN npm i -g esm && npm cache clean --force;
RUN npm i -g concurrently && npm cache clean --force;
RUN npm i -g nodemon && npm cache clean --force;
RUN yarn install --production=true && yarn cache clean;


WORKDIR /usr/src/app/client
RUN yarn
RUN yarn run build

WORKDIR /usr/src/app/server
RUN yarn install --production=true && yarn cache clean;

WORKDIR /usr/src/app
EXPOSE 12400

CMD [ "yarn", "run", "server" ]