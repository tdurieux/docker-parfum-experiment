FROM    debian:buster

ENV     TOR_HOME            /var/lib/tor
ENV     TOR_URL             https://archive.torproject.org/tor-package-archive
ENV     TOR_VERSION         0.4.2.7
ENV     TOR_GPG_KS_URI      hkp://keyserver.ubuntu.com:80
ENV     TOR_GPG_KEY1        0xEB5A896A28988BF5
ENV     TOR_GPG_KEY2        0xC218525819F78451
ENV     TOR_GPG_KEY3        0x21194EBB165733EA
ENV     TOR_GPG_KEY4        0x6AFEE6D49E92B601

ENV     GOLANG_DL_URL       https://dl.google.com/go
ENV     GOLANG_ARCHIVE      go1.11.13.linux-amd64.tar.gz
ENV     GOLANG_SHA256       50fe8e13592f8cf22304b9c4adfc11849a2c3d281b1d7e09c924ae24874c6daa

ENV     OBFS4_URL           https://github.com/Yawning/obfs4.git
ENV     OBFS4_VERSION       0.0.11


# Install Tor
RUN     set -ex && \
        apt-get update && \
        apt-get install -y git libevent-dev zlib1g-dev libssl-dev gcc make automake ca-certificates autoconf musl-dev coreutils gpg wget && \
        mkdir -p /usr/local/src/ && \
        cd /usr/local/src && \
        wget -qO "tor-$TOR_VERSION.tar.gz" "$TOR_URL/tor-$TOR_VERSION.tar.gz" && \
        wget -qO "tor-$TOR_VERSION.tar.gz.asc" "$TOR_URL/tor-$TOR_VERSION.tar.gz.asc" && \
        gpg --keyserver "$TOR_GPG_KS_URI" --recv-keys "$TOR_GPG_KEY1" && \
        gpg --keyserver "$TOR_GPG_KS_URI" --recv-keys "$TOR_GPG_KEY2" && \
        gpg --keyserver "$TOR_GPG_KS_URI" --recv-keys "$TOR_GPG_KEY3" && \
        gpg --keyserver "$TOR_GPG_KS_URI" --recv-keys "$TOR_GPG_KEY4" && \
        gpg --verify "tor-$TOR_VERSION.tar.gz.asc" && \
        tar -xzvf "tor-$TOR_VERSION.tar.gz" -C /usr/local/src && \
        cd "/usr/local/src/tor-$TOR_VERSION" && \
        ./configure \
            --disable-asciidoc \
            --sysconfdir=/etc \
            --disable-unittests && \
        make && make install && \
        cd .. && \
        rm -rf "tor-$TOR_VERSION" && \
        rm "tor-$TOR_VERSION.tar.gz" && \
        rm "tor-$TOR_VERSION.tar.gz.asc"

# Install Golang & OBFS4 proxy
RUN     cd /usr/local/src && \
        echo "$GOLANG_SHA256 *$GOLANG_ARCHIVE" > GO_CHECKSUMS && \
        wget "$GOLANG_DL_URL/$GOLANG_ARCHIVE" && \
        sha256sum -c GO_CHECKSUMS 2>&1 | grep OK && \
        tar -C /usr/local/lib -xzf "$GOLANG_ARCHIVE" && \
        ln -s /usr/local/lib/go/bin/go /usr/local/bin/ && \
        git clone "$OBFS4_URL" /usr/local/src/obfs4proxy && \
        cd obfs4proxy && \
        git checkout "tags/obfs4proxy-$OBFS4_VERSION" && \
        go build -o obfs4proxy/obfs4proxy ./obfs4proxy && \
        cp ./obfs4proxy/obfs4proxy /usr/local/bin && \
        cd .. && \
        rm "$GOLANG_ARCHIVE" && \
        rm -rf obfs4proxy

# Create group & user tor
RUN     addgroup --system -gid 1107 tor && \
        adduser --system --ingroup tor -uid 1104 tor

# Create /etc/tor directory
RUN     mkdir -p /etc/tor/ && \
        chown -Rv tor:tor /etc/tor

# Create .tor subdirectory of TOR_HOME
RUN     mkdir -p "$TOR_HOME/.tor" && \
        chown -Rv tor:tor "$TOR_HOME" && \
        chmod -R 750 "$TOR_HOME"

# Copy restart script
COPY    ./restart.sh /restart.sh

RUN     chown tor:tor /restart.sh && \
        chmod u+x /restart.sh && \
        chmod g+x /restart.sh

# Copy wait-for-it script
COPY    ./wait-for-it.sh /wait-for-it.sh

RUN     chown tor:tor /wait-for-it.sh && \
        chmod u+x /wait-for-it.sh && \
        chmod g+x /wait-for-it.sh

# Expose socks port 
EXPOSE  9050

# Switch to user tor
USER    tor
