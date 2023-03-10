FROM golang:1.16 AS builder
WORKDIR /go/src/
ADD /master master/
ADD /common common/
ADD go.mod .
ADD go.sum .
WORKDIR /go/src/master
RUN go get;
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build  -a -installsuffix cgo  -o master

FROM scratch
COPY --from=builder /go/src/master/master  /
CMD ["/master"]