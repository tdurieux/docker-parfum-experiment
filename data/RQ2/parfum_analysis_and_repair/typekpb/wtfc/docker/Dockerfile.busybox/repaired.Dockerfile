FROM progrium/busybox:latest

RUN \

    mv /lib/libgcc_s.so.1 /lib/libgcc_s.so.1.bak && \
    opkg-install curl ca-certificates make coreutils-timeout && \
    sh -c "$( curl -f -L https://raw.github.com/rylnd/shpec/master/install.sh)" -f

VOLUME "/tmp/wtfc"
WORKDIR "/tmp/wtfc"

CMD sh -c shpec