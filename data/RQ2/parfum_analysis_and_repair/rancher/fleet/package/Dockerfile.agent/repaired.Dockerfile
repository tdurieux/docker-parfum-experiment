FROM registry.suse.com/bci/bci-base:15.4.27.8.3
ARG ARCH
ENV ARCH=$ARCH
RUN zypper in --no-recommends -y git bash openssh && useradd -m -U fleet-apply; rm -fr /var/cache/* /var/log/*log
COPY bin/fleetagent-linux-$ARCH /usr/bin/fleetagent
COPY bin/fleet-linux-$ARCH /usr/bin/fleet
COPY package/log.sh /usr/bin/
USER fleet-apply
CMD ["fleetagent"]