# example images
FROM golang:alpine as builder
RUN go version
RUN apk add --no-cache git
COPY . /go/src/github.com/jaypipes/gsr
WORKDIR /go/src/github.com/jaypipes/gsr
RUN set -x && \
    go get github.com/golang/dep/cmd/dep && \
    dep ensure -v
WORKDIR /go/src/github.com/jaypipes/gsr/examples/cmd/web
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

# Take the built binary from the builder image and place it into a new
# from-scratch image, reducing the resulting image size substantially
FROM scratch
COPY --from=builder /go/src/github.com/jaypipes/gsr/examples/cmd/web/main /app/
WORKDIR /app
CMD ["./main"]
