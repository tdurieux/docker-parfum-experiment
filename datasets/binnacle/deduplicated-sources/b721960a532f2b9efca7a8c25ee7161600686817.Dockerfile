FROM alpine
LABEL "Maintainer"="Scott Hansen <firecat4153@gmail.com>"

# Install openvpn
RUN apk --no-cache --no-progress add curl openvpn && \
    printf '#!/usr/bin/env sh\n/usr/local/bin/port_forward.sh &\n' > /usr/local/bin/up.sh && \
    chmod +x /usr/local/bin/up.sh && \
    rm -rf /tmp/*

COPY port_forward.sh /usr/local/bin/port_forward.sh

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -L 'https://api.ipify.org'

VOLUME ["/config"]

ENTRYPOINT openvpn \
                --cd /config \
                --config /config/pia.ovpn \
                --inactive 3600 \
                --keepalive 10 60 \
                --mssfix 1460 \
                --route-delay 2 \
                --route-up "/sbin/ip route del default" \
                --script-security 2 \
                --setenv LOCAL_NETWORK $LOCAL_NETWORK \
                --up /usr/local/bin/up.sh \
                --up-delay
