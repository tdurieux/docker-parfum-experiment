FROM alpine:3.14
RUN apk add --no-cache --update bash openvpn easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    wget https://github.com/pashcovich/openvpn-user/releases/download/v1.0.3/openvpn-user-linux-amd64.tar.gz -O - | tar xz -C /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
COPY setup/ /etc/openvpn/setup
RUN chmod +x /etc/openvpn/setup/configure.sh
