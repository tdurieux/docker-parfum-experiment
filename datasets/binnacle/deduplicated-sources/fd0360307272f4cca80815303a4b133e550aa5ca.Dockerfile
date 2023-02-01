FROM node:8.11

ENV PATH /opt/outline/node_modules/.bin:/opt/node_modules/.bin:$PATH
ENV NODE_PATH /opt/outline/node_modules:/opt/node_modules
ENV APP_PATH /opt/outline
RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH
COPY . $APP_PATH

RUN yarn install --pure-lockfile
RUN cp -r /opt/outline/node_modules /opt/node_modules

CMD yarn build && yarn start
