FROM node:10

WORKDIR /app

COPY . ./

ENV NODE_ENV production

RUN npm install --prod && npm cache clean --force;

ENTRYPOINT ["node", "./bin/www"]
