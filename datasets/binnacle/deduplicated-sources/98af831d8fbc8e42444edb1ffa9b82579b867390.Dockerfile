FROM alpine:3.9
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

ENV USERNAME=samba
EXPOSE 7137 7138 7139 7445
VOLUME /shared

RUN set -xe \
    && mkdir /config \
    && apk add --no-cache samba samba-common-tools

COPY smb.conf /config/smb.conf
COPY run.sh /usr/local/bin/run.sh
COPY s6.d /etc/s6.d

RUN set -xe \
    && adduser -D $USERNAME \
    && PASSWORD=$(cat /dev/urandom | tr -dc "a-zA-Z0-9-_" | fold -w 50 | head -n1) \
    && (echo "$PASSWORD"; echo "$PASSWORD") | smbpasswd -sa -c /config/smb.conf $USERNAME \
    && chmod -R +x /usr/local/bin/run.sh /etc/s6.d \
    && chown -R $USERNAME:$USERNAME /etc/s6.d /var/log/samba /var/cache/samba /var/lib/samba /var/run/samba

CMD ["run.sh"]
