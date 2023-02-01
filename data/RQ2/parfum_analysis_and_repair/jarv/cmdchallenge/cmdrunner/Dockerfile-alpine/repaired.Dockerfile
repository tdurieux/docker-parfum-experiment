FROM alpine
RUN apk add --no-cache bash
ADD var.tar.gz /
