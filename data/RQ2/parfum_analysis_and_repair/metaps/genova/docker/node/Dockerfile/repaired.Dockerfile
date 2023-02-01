FROM node:18-alpine

ENV APP_HOME=/app/frontend
WORKDIR $APP_HOME

COPY frontend $APP_HOME/

RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD ["yarn", "watch"]
