FROM golang:alpine as builder
RUN apk --no-cache update && apk --no-cache add gcc musl-dev git make bash
WORKDIR /build
COPY . .
RUN GOOS=linux GOARCH=amd64 make mini

FROM alpine
RUN apk --no-cache update
WORKDIR /bin
COPY --from=builder /build/bin/mini mini
CMD ["./mini"]