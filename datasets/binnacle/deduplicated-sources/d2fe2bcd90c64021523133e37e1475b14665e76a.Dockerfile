# Docker builder for Golang
FROM golang as builder
LABEL maintainer "Vincent RABAH <vincent.rabah@gmail.com>"

WORKDIR ${GOPATH}/src/github.com/user/app
COPY . .
RUN set -x && \ 
    go get -d -v . && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Docker run Golang app
FROM scratch
LABEL maintainer "Vincent RABAH <vincent.rabah@gmail.com>"

WORKDIR /root/
COPY --from=builder ${GOPATH}/src/github.com/user/app .
CMD ["./app"]  
