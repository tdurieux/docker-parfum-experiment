FROM alpine:3.11

EXPOSE 80

RUN apk update && apk add --no-cache nginx curl && mkdir /run/nginx

ENTRYPOINT ["nginx", "-g", "daemon off;"]
