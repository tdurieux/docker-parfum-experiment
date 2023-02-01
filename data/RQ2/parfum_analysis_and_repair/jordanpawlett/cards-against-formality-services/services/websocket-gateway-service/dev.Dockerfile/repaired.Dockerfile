FROM node:12.15.0-alpine
WORKDIR /home/service/websocket-gateway-service
COPY ./package.json ./
RUN yarn && yarn cache clean;
COPY . .
ENV NODE_ENV=development
CMD yarn run dev