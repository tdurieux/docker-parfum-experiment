FROM golang:1.13-alpine AS build-stage

RUN mkdir -p /go/src/digi.dev/digivice/runtime/admission
WORKDIR /go/src/digi.dev/digivice/runtime/admission

COPY go.mod .
COPY go.sum .

RUN go mod download

# This should be built at the project root
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/dac --ldflags "-w -extldflags '-static'" "digi.dev/digivice/runtime/admission/cmd"

# Final image.
FROM alpine:latest
RUN apk --no-cache add \
  ca-certificates
COPY --from=build-stage /bin/dac /usr/local/bin/dac
ENTRYPOINT ["/usr/local/bin/dac"]
