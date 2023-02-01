FROM nginx:1.19.3-alpine
RUN apk update && apk upgrade && \
    apk add --no-cache curl
WORKDIR /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY build .
HEALTHCHECK CMD [ curl -f https://localhost:4010/user-count/metrics || exit 1]
  