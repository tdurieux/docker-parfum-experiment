FROM node:14

WORKDIR /app

COPY package*.json ./
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build
EXPOSE 3000
CMD [ "yarn", "start" ]
