FROM node:latest as build-stage

RUN mkdir /game_rps
RUN mkdir /game_rps/client
WORKDIR /game_rps

ADD game_engine ./game_engine

ADD client/src ./client/src
ADD client/webpack ./client/webpack
ADD client/package.json ./client
ADD client/index.html ./client
ADD client/.babelrc ./client

WORKDIR client
RUN npm install && npm cache clean --force;
RUN npm run build


FROM nginx as production-stage
RUN mkdir /app
COPY --from=build-stage /game_rps/client/dist /app
COPY client/nginx.conf /etc/nginx/nginx.conf	
