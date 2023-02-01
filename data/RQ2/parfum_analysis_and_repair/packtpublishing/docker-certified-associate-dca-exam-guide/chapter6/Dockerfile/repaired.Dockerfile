FROM alpine:3.8
RUN apk add --no-cache --update curl
CMD ping 8.8.8.8 -c 300
