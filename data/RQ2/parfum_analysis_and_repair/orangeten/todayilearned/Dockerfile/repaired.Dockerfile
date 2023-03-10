FROM node:9.10.0

WORKDIR /app
COPY tilup-web/package.json tilup-web/yarn.lock tilup-web/
RUN cd tilup-web && \
 yarn install && yarn cache clean;
COPY tilup-server/package.json tilup-server/yarn.lock tilup-server/
RUN cd tilup-server && \
  yarn install && yarn cache clean;

COPY . .
RUN cd tilup-web && \
 yarn run build && yarn cache clean;

EXPOSE 3000

CMD cd tilup-server &&\
  wget -O .env $DOTENVURL &&\
  node app.js
