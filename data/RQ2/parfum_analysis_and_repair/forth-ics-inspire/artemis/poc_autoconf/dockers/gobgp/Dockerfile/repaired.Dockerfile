FROM alpine

RUN wget https://github.com/osrg/gobgp/releases/download/v2.18.0/gobgp_2.18.0_linux_amd64.tar.gz && \
    tar -xzvf gobgp_2.18.0_linux_amd64.tar.gz && \
    mv gobgp gobgpd /usr/bin && rm gobgp_2.18.0_linux_amd64.tar.gz

RUN mkdir /etc/gobgp

EXPOSE 179

ENTRYPOINT gobgpd -f /etc/gobgp/gobgp.conf
