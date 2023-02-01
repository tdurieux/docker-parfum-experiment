FROM alpine:latest

COPY meteor /usr/bin/meteor
RUN apk update
RUN apk add --no-cache ca-certificates

CMD ["meteor"]
