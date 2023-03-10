FROM alpine:latest

RUN apk add --no-cache sudo bash curl libc6-compat && \
    echo "cloudcontrol ALL=(root)NOPASSWD:/sbin/apk *" > /etc/sudoers.d/cloudcontrol && \
    echo "cloudcontrol ALL=(root)NOPASSWD:/usr/local/bin/az *" >> /etc/sudoers.d/cloudcontrol && \
    echo "cloudcontrol ALL=(root)NOPASSWD:/bin/chmod *" >> /etc/sudoers.d/cloudcontrol && \
    adduser -D cloudcontrol && \
    mkdir /home/cloudcontrol/bin && \
    chown cloudcontrol /home/cloudcontrol/bin

# Flavour

COPY flavour/simple/flavour /home/cloudcontrol/flavour
COPY flavour/simple/flavourinit.sh /home/cloudcontrol/bin/flavourinit.sh
RUN chmod +x /home/cloudcontrol/bin/flavourinit.sh
