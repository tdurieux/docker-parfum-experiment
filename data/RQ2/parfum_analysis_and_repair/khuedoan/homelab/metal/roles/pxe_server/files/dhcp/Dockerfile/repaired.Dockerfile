FROM alpine:20220316

RUN apk add --no-cache dhcp

RUN touch /var/lib/dhcp/dhcpd.leases

CMD [ "dhcpd", "-d", "-f", "-cf", "/etc/dhcp/dhcpd.conf" ]
