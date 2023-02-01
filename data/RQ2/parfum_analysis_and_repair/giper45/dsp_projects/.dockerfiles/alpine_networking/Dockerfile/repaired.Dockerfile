FROM dockersecplayground/alpine:latest

RUN apk --update --no-cache add curl wget lftp heimdal-telnet tcpdump
