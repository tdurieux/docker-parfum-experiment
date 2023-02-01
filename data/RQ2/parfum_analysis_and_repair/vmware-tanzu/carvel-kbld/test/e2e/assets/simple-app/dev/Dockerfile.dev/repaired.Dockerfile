FROM golang:1.10.1
WORKDIR /go/src/github.com/mchmarny/simple-app/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o app
RUN cp /go/src/github.com/mchmarny/simple-app/app /app
EXPOSE 8080
ENTRYPOINT ["/app"]