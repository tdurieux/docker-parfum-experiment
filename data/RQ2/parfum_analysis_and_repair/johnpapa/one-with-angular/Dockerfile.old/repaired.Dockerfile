FROM node:6.11-alpine as angular-app

LABEL authors="Shayne Boyer, John Papa"

#Linux setup
RUN apk update \
  && apk add --update alpine-sdk \
  && apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache clear --force \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd

# Copy and install the Angular app
RUN npm install -g @angular/cli && npm cache clean --force;

WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app
RUN ng build --prod

#Express server =======================================
FROM node:6.11-alpine as express-server
WORKDIR /app
COPY /src/server /app
RUN npm install --production --silent && npm cache clean --force;

#Final image ========================================
FROM node:6.11-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY --from=express-server /app /usr/src/app
COPY --from=angular-app /app/dist /usr/src/app
ENV PORT 80

CMD [ "node", "index.js" ]
