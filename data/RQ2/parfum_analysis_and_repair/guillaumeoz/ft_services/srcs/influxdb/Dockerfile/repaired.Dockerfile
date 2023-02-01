FROM alpine:latest

RUN apk add --no-cache influxdb; \
	apk add --no-cache openrc; \
  apk add --no-cache ca-certificates

EXPOSE	8086

CMD 	influxd run -config /etc/influxdb.conf