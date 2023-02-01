FROM node:10.19-alpine3.11

WORKDIR /app
RUN apk add --no-cache python make g++
ADD package.json package-lock.json ./
RUN npm install && npm cache clean --force;

ADD babel.config.js .
ADD vue.config.js .
ADD .browserslistrc .
ADD .eslintrc.js .
ADD .prettierrc .
ADD .env .

VOLUME [ "/app/src" ]
VOLUME [ "/app/public" ]

CMD ["npm", "run", "serve"]
