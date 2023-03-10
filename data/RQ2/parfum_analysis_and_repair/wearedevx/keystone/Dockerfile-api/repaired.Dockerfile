FROM golang:1.16
ENV CGO_ENABLED 0

RUN go get github.com/go-delve/delve/cmd/dlv
RUN go install github.com/cespare/reflex@latest
RUN curl -f -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz
RUN cp migrate.linux-amd64 /usr/local/bin/migrate

