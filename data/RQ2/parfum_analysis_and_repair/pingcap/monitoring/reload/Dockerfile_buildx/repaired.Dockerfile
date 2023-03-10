FROM golang:1.17 as builder
WORKDIR /app
COPY go.mod go.sum ./
COPY reload ./reload
RUN CGO_ENABLED=0 go build -v ./reload/main.go

FROM busybox:1.34.1
COPY --from=builder /app/main  /bin/reload
ENTRYPOINT [ "/bin/reload" ]
CMD        [ "--watch-path=/etc/prometheus/rules", \
             "--prometheus-url=http://127.0.0.1:9090" ]