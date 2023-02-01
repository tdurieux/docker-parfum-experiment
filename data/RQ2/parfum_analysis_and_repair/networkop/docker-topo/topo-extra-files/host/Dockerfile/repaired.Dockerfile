FROM alpine:latest

RUN apk update && \
    apk add --no-cache libteam && \
    apk add --no-cache open-lldp && \
    apk add --no-cache sudo && \
    apk add --no-cache tcpdump && \
    apk add --no-cache scapy && \
    apk add --no-cache iperf3

RUN adduser -u 1000 -G wheel -D alpine && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY entrypoint.sh /home/alpine/
RUN chmod +x /home/alpine/entrypoint.sh

USER alpine

ENTRYPOINT ["/home/alpine/entrypoint.sh"]

CMD []
