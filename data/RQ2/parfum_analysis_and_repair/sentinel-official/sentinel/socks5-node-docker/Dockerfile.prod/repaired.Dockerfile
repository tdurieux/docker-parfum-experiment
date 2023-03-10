FROM alpine

ADD sentinel /root/sentinel

ADD app.py server.py run.sh /root/

ENV SENT_ENV=PROD

RUN echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk add --no-cache ca-certificates easy-rsa mongodb openvpn ufw@testing && \
    mkdir -p /data/db && \
    wget -c https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && \
    python /tmp/get-pip.py && \
    pip install --no-cache-dir falcon gunicorn pymongo requests speedtest_cli && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /root/.cache .wget-hsts

EXPOSE 1194/udp 3000

ENTRYPOINT ["sh", "/root/run.sh"]