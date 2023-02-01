FROM golang:1.18-alpine as build
RUN apk add --no-cache -u git
WORKDIR /app
COPY . .
RUN go build -o /krok

FROM alpine
RUN apk add --no-cache -u ca-certificates
COPY --from=build /krok /app/

EXPOSE 9998

RUN mkdir -p /tmp/krok/vault
WORKDIR /app/
ENTRYPOINT [ "/app/krok" ]
