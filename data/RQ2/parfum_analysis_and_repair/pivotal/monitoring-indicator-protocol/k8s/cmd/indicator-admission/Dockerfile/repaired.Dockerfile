FROM golang:1.13 as builder

WORKDIR /root

ENV GOOS=linux \
    GOARCH=amd64 \
    CGO_ENABLED=0

COPY /go.mod /go.sum /root/

RUN go version && \
    go mod download

COPY / /root/

RUN go build \
    -a \
    -installsuffix nocgo \
    -o /indicator-admission \
    -mod=readonly \
    k8s/cmd/indicator-admission/main.go

FROM scratch

COPY --from=builder /indicator-admission /srv/
WORKDIR /srv
CMD [ "/srv/indicator-admission" ]