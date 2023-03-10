###multistage build

##stage 1. build the react app
FROM node:14.1-alpine AS builder

WORKDIR /opt/web
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
ENV PATH="./node_modules/.bin:$PATH"
COPY . ./
RUN npm run build

##stage 2. build the production (server) environment
FROM nginx:1.17-alpine

#install curl and envsubst
RUN apk --no-cache add curl
RUN apk --no-cache add bash
RUN curl -f -L https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-`uname -s`-`uname -m` -o envsubst && \
    chmod +x envsubst && \
    mv envsubst /usr/local/bin

#set environment variables
ENV REACT_APP_API_URL=https://app-backend-test-001.azurewebsites.net
ENV REACT_APP_RECAPTCHA_SITEKEY=6Lc0JOAbAAAAAIv3CYhhU6lHzHovl0yfMhI7mDl8
ENV REACT_APP_SENTRY_DSN=https://b0ca2fb00555461ba86f659a99cceb37@o1287611.ingest.sentry.io/6526369

#copy config file over to the template
COPY ./nginx.config /etc/nginx/nginx.template

#set working directory to nginx folder
WORKDIR /usr/share/nginx/html

#copy and activate files used to set dynamic environment variables
COPY ./env.sh .
COPY .env.development .
RUN chmod +x env.sh

# run script to set window environment variables at build time
RUN bash env.sh
CMD ["/bin/sh", "-c", "/usr/share/nginx/html/env.sh"]

#substitute out default.conf file with nginx.template AND start the nginx server
CMD ["/bin/sh", "-c", "envsubst < /etc/nginx/nginx.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]

# generate react Static Build files for nginx to use
COPY --from=builder /opt/web/build /usr/share/nginx/html



