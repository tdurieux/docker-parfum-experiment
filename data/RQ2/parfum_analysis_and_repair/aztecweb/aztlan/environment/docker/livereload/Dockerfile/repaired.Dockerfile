FROM node:14-alpine

RUN apk update && apk upgrade

RUN npm install -g livereload && npm cache clean --force;

CMD livereload "assets,inc/src,themes" -e 'php,js,jsx,styl'

WORKDIR /app

EXPOSE 35729
