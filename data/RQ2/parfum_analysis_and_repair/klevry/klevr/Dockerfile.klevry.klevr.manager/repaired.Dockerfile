## Multi stage build 1st
FROM golang:1.16 as builder

RUN go get -u github.com/swaggo/swag/cmd/swag
RUN GOPATH=`go env | grep GOPATH | sed -n 's/^GOPATH=//p' | sed -n 's/"//gp'`
RUN mkdir /usr/src/klevr && rm -rf /usr/src/klevr
WORKDIR /usr/src/klevr
COPY . /usr/src/klevr/

WORKDIR /usr/src/klevr/pkg/manager
RUN ${GOPATH}/bin/swag init -g server.go --parseDependency --parseInternal true

WORKDIR /usr/src/klevr
RUN go mod tidy
RUN chmod +x build.manager.sh
RUN sh ./build.manager.sh


## Main build
FROM alpine:3.13.2
LABEL version=0.4

RUN apk update && apk add --no-cache curl bash vim

RUN mkdir /conf
COPY ./conf/* /conf/
COPY --from=builder /usr/src/klevr/Dockerfiles/manager/klevr-manager /
COPY ./Dockerfiles/manager/init-db.sh /
COPY ./Dockerfiles/manager/entrypoint.sh /
ENTRYPOINT ./entrypoint.sh
EXPOSE 8090
