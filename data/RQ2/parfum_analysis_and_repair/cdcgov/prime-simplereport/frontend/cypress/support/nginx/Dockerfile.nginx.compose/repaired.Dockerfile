FROM nginx:1.21.1-alpine
COPY ./cypress/support/nginx/compose.conf /etc/nginx/conf.d/default.conf