FROM bluefoxicy/proftpd

ENV PROFTPD_PASSIVE_PORTS="31100-31150"
ENV PROFTPD_AUTH_ORDER="mod_auth_pam.c* mod_auth_unix.c"
ENV PROFTPD_TLS="on"
ENV PROFTPD_TLS_REQUIRED="off"

RUN echo "AllowForeignAddress on" >> /etc/proftpd/proftpd.conf

EXPOSE 21