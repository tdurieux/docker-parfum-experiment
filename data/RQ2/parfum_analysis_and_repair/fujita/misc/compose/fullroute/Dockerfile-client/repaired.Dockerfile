FROM alpine as builder

ENV HOME /root
WORKDIR /root

RUN apk add --no-cache --update wget

RUN wget https://github.com/osrg/gobgp/releases/download/v2.11.0/gobgp_2.11.0_linux_amd64.tar.gz
RUN tar xzf gobgp_2.11.0_linux_amd64.tar.gz && rm gobgp_2.11.0_linux_amd64.tar.gz


FROM alpine

RUN apk add --no-cache --update supervisor

ADD supervisord.conf /etc/
ADD start-client-gobgpd /usr/bin/start-gobgpd


COPY --from=builder /root/gobgpd /usr/bin
COPY --from=builder /root/gobgp /usr/bin

ENTRYPOINT ["/usr/bin/supervisord"]
