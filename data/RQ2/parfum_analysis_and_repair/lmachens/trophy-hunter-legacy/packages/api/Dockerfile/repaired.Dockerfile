FROM node:lts-alpine
LABEL maintainer="leon.machens@gmail.com"

EXPOSE 5000

RUN npm install -g yarn && npm cache clean --force;
COPY package.json package.json
RUN yarn install && yarn cache clean;

COPY dist dist

CMD ["node", "dist/server.js"]