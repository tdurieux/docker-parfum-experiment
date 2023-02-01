# This is based (loosely) on https://github.com/nginxinc/docker-nginx/blob/master/mainline/stretch/Dockerfile.

FROM alpine:3.16.0

RUN apk --no-cache add nginx

# Forward request and error logs to stdout / stderr