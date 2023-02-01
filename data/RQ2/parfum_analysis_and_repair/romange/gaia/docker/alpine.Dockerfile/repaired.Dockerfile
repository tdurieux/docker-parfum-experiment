FROM  frolvlad/alpine-gxx

RUN apk update && \
    apk upgrade && \
    apk add --no-cache git autoconf automake libtool make linux-headers

