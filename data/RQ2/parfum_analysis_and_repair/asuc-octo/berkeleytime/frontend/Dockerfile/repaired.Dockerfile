FROM node:12-slim AS dev
RUN mkdir /frontend
WORKDIR /frontend
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .
ENTRYPOINT npm start

FROM dev AS prod
RUN npm install -g serve && npm cache clean --force;
RUN npm run build
RUN rm -rf node_modules
ENTRYPOINT npm run prod
