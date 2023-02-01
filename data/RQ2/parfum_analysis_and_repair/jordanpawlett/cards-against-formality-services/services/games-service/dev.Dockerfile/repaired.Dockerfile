FROM node:12.15.0-alpine
WORKDIR /home/service/games-service
COPY ./package.json ./
RUN yarn && yarn cache clean;
COPY . .
CMD yarn run dev