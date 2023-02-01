FROM node:lts-alpine
ENV NODE_ENV=development
WORKDIR /usr/src/app
COPY gulpfile.js .stylelintrc package.json package-lock.json /usr/src/app/
RUN npm install && npm cache clean --force;
RUN chown -R node /usr/src/app
