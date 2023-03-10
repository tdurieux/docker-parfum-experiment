FROM bluefoxicy/proftpd

ENV PROFTPD_PASSIVE_PORTS="21100-21150"
ENV PROFTPD_AUTH_ORDER="mod_auth_pam.c* mod_auth_unix.c"
ENV PROFTPD_DEFAULT_ROOT="/home/prouser"
ENV PROFTPD_TLS="on"
ENV PROFTPD_TLS_REQUIRED="off"


VOLUME ["/home/prouser"]

RUN echo "AllowForeignAddress on" >> /etc/proftpd/proftpd.conf
RUN echo "MasqueradeAddress 127.0.0.1" >> /etc/proftpd/proftpd.conf

RUN useradd prouser
RUN echo 'prouser:prouser' | chpasswd

EXPOSE 21