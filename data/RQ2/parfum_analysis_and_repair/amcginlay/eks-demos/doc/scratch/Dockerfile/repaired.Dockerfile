FROM golang:1.12.0-alpine3.9
ENV PORT=80
WORKDIR /app/
COPY echo-server.go .
RUN go build -o echo-server && \
    apk add --no-cache curl
ENTRYPOINT [ "/echo-server" ]
