FROM golang:1-alpine as builder


WORKDIR /root

# ENV GOFLAGS "-mod=readonly"
ARG version

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY cmd cmd 
COPY internal internal
COPY model model
COPY messenger messenger
COPY apis apis

RUN echo $version

RUN go build -ldflags="-X 'github.com/livepeer/stream-tester/model.Version=$version' -X 'github.com/livepeer/stream-tester/model.IProduction=true'" cmd/mist-api-connector/mist-api-connector.go


FROM alpine
RUN apk add --no-cache ca-certificates

WORKDIR /root
COPY --from=builder /root/mist-api-connector mist-api-connector