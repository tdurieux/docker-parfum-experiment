##################################################### BUILD STAGE ######################################################
FROM golang:alpine AS build

RUN apk add --no-cache -U make git mercurial subversion

RUN git clone https://github.com/goproxyio/goproxy.git /src/goproxy && \
    cd /src/goproxy && \
    export CGO_ENABLED=0 && \
    make

################################################## PRODUCTION STAGE ####################################################