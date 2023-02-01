FROM ubuntu:15.10
MAINTAINER Roland Bracewell Shoemaker <roland@letsencrypt.org>

RUN apt-get update && apt-get install -y softhsm git-core build-essential cmake libssl-dev libseccomp-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/SUNET/pkcs11-proxy && \
    cd pkcs11-proxy && \
    cmake . && make && make install

COPY key.pem /root/key.pem

RUN echo "0:/var/lib/softhsm/slot0.db" > /etc/softhsm/softhsm.conf && \
    softhsm --init-token --slot 0 --label key --pin 1234 --so-pin 0000 && \
    softhsm --import /root/key.pem --slot 0 --label key --id BEEF --pin 1234

EXPOSE 5657
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:5657"
CMD [ "/usr/local/bin/pkcs11-daemon", "/usr/lib/softhsm/libsofthsm.so" ]

