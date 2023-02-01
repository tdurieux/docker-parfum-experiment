FROM node:10.19-alpine3.11 AS BUILDER

WORKDIR /app
RUN apk add --no-cache python make g++
ADD package.json package-lock.json ./
RUN npm install && npm cache clean --force;

ADD babel.config.js .
ADD vue.config.js .
ADD .browserslistrc .
ADD .eslintrc.js .
ADD .prettierrc .
ADD .env.production .

COPY src ./src
COPY public ./public

RUN npm run build

FROM node:alpine

WORKDIR /app

RUN npm install -g serve && npm cache clean --force;

COPY --from=BUILDER /app/dist ./

CMD serve -s -l $PORT
