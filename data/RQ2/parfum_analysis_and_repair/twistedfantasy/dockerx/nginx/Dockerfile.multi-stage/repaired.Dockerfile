# form-wizard
FROM node:10.6.0-alpine as form-wizard-builder

RUN mkdir -p /usr/src/form-wizard && rm -rf /usr/src/form-wizard
WORKDIR /usr/src/form-wizard

ENV PATH /usr/src/form-wizard/node_modules/.bin:$PATH

COPY form-wizard/package.json ./
COPY form-wizard/package-lock.json ./
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@1.1.5 -g --silent && npm cache clean --force;

COPY form-wizard/ /usr/src/form-wizard

RUN npm run build-prod

# nginx
FROM nginx:1.15.5-alpine
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

EXPOSE 80
EXPOSE 443

RUN mkdir -p /usr/share/nginx/html/form-wizard

COPY nginx.conf /etc/nginx/nginx.conf
COPY test.conf /etc/nginx/conf.d/default.conf
COPY .htpasswd /etc/nginx/.htpasswd

COPY --from=form-wizard-builder /usr/src/form-wizard/build/ /usr/share/nginx/html/form-wizard
