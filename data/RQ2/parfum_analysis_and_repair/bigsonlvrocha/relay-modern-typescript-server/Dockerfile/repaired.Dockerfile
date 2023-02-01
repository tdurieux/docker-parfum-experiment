FROM node:alpine
WORKDIR /srv/app
COPY . .
RUN yarn install && yarn cache clean;
RUN npm install -g ts-node && npm cache clean --force;
ENV NODE_ENV development
CMD [ "npx", "ts-node", "--files", "src/index.ts" ]
