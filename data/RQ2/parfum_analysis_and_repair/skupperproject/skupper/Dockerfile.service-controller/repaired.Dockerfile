FROM golang:1.13 AS builder

WORKDIR /go/src/app
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .

RUN make

FROM node:12.18 AS console-builder

WORKDIR /skupper-console/
ADD https://github.com/skupperproject/gilligan/archive/master.tar.gz .
RUN tar -zxf master.tar.gz && rm master.tar.gz
WORKDIR ./gilligan-master
RUN yarn install && yarn build && yarn cache clean;

FROM registry.access.redhat.com/ubi8-minimal

WORKDIR /app
COPY --from=builder /go/src/app/service-controller .
COPY --from=builder /go/src/app/get /usr/local/bin/get
COPY --from=console-builder /skupper-console/gilligan-master/build/ console
CMD ["/app/service-controller"]
