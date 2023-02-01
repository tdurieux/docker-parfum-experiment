FROM node:16.13

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY package.json $APP_HOME

COPY . $APP_HOME

RUN npm i -g pnpm@6.32.11 && pnpm i && pnpm run build

ENV HOST=0.0.0.0 PORT=4200

EXPOSE ${PORT}
CMD [ "yarn", "start:prod" ]
