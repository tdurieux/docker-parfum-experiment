FROM golang:1.9.2-alpine3.6 as builder
WORKDIR /go/src/github.com/dev4cloud/copycat/
COPY copycat.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' .

FROM scratch
COPY --from=builder /go/src/github.com/dev4cloud/copycat/copycat .
CMD ["./copycat"]