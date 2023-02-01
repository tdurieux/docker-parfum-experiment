FROM alpine:3.14
RUN apk add --no-cache tcpdump
CMD tcpdump -i eth0
