FROM node:8

ENV APP_DIR /kails
RUN mkdir $APP_DIR
WORKDIR $APP_DIR
ADD package.json $APP_DIR
RUN npm install && npm cache clean --force;
ADD . $APP_DIR

RUN npm run build
RUN npm run assets_compile

EXPOSE 5000

CMD ["npm", "run", "pm2:docker"]
