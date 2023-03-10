FROM alpine:latest

RUN apk add --no-cache supervisor tini gettext samba-dc

ADD fixtures/samba-ad/docker-entrypoint.sh /
ADD fixtures/samba-ad/samba-ad-config.sh /
ADD fixtures/samba-ad/smb.conf.tmpl /
ADD fixtures/samba-ad/kerberos-client-config.sh /
ADD fixtures/samba-ad/krb5.conf.tmpl /
ADD fixtures/samba-ad/supervisord.conf /etc/supervisord.conf

VOLUME /var/lib/krb5kdc

EXPOSE 464 88

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]