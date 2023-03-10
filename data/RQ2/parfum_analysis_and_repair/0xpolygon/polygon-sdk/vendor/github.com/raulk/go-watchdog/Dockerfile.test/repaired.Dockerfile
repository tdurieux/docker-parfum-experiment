FROM golang:1.15.5
WORKDIR /watchdog
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go test -c -o watchdog.test

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /watchdog/watchdog.test .
CMD ["/root/watchdog.test", "-test.v"]