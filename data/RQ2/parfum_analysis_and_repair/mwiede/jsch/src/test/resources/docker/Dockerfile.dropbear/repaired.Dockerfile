FROM alpine:3.12
RUN apk update && \
    apk upgrade && \
    apk add --no-cache dropbear openssh && \
    rm /var/cache/apk/* && \
    mkdir /etc/dropbear && \
    mkdir /root/.ssh && \
    chmod 700 /root/.ssh
COPY dropbear_rsa_host_key /etc/dropbear/
COPY authorized_keys /root/.ssh/
RUN chmod 600 /etc/dropbear/dropbear_*_key /root/.ssh/authorized_keys
RUN passwd -u root
ENTRYPOINT ["/usr/sbin/dropbear", "-F", "-s", "-E"]
