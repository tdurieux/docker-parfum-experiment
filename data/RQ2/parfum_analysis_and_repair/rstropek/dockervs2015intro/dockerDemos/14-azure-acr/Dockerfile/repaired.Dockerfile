FROM nginx:alpine
LABEL maintainer="rainer@timecockpit.com"
COPY *.html /usr/share/nginx/html/