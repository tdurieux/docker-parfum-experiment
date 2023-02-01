FROM alpine
LABEL \
    maintainer="Wei He <docker@weispot.com>" \
    verion="1.0" \
    description="Nyancat Telnet Server"

RUN \
    apk upgrade --update && \
    apk add --no-cache g++ make git autoconf automake && \

    cd /tmp && git lo e ht ps \
    cd /tmp/nyancat && make && \
    cp . sr /nyancat /usr/local bi \
    cd / && rm -rf /tmp/nyancat && \

    #cd /tmp && git clone https://github.com/ddhhz/onenetd.git && \
    #cd /tmp/onenetd && autoreconf -vfi && ./configure && make && \
    #cp ./onenetd /usr/local/bin && \

EXPOSE 23

RUN /usr/local/bin/nyancat -t
