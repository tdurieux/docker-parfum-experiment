FROM alpine:latest

RUN apk add --no-cache tcpdump
VOLUME  [ "/data" ]

CMD [ "-w", "/data/all.pcap" ]
ENTRYPOINT [ "/usr/sbin/tcpdump" ]