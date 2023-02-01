FROM node

WORKDIR /usr/src/app
ADD package.json .
RUN npm -G install yarn && yarn install && yarn cache clean;
COPY . .
RUN mkdir -p ~/.pm2/node_modules/
EXPOSE 5500
ENTRYPOINT ./start.sh
