# Dockerfile
FROM node:16.13.2-alpine

# create destination directory
RUN mkdir -p /usr/src/nuxt-app && rm -rf /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app

# update and install dependency
RUN apk update && apk upgrade
RUN apk add --no-cache git

# copy the app, note .dockerignore
COPY . /usr/src/nuxt-app/
RUN npm install && npm cache clean --force;
RUN npm run build

EXPOSE 3000

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

CMD [ "npm", "start" ]