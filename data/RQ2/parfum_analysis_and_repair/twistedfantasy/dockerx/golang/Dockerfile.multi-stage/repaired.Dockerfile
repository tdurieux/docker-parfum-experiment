ARG BUILDER_IMAGE
FROM $BUILDER_IMAGE as builder
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

RUN mkdir -p /var/app
WORKDIR /var/app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

ARG IMAGE
FROM $IMAGE
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /var/app/main .

EXPOSE 8000

CMD ["./main"]