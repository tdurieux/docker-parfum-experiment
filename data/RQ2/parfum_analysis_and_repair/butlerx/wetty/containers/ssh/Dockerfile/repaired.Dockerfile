FROM sickp/alpine-sshd:latest
RUN adduser -D -h /home/term -s /bin/sh term && \
    ( echo "term:term" | chpasswd )