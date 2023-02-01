FROM alpine:3.9
RUN apk add --no-cache wireshark-common
ENTRYPOINT ["text2pcap"]
