# FROM BASE_IMAGE
# ENV container docker
# MAINTAINER "Antony Antony" <antony@phenome.org>
# Don't start any optional services except for the few we need.
ENV DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTED=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get -y --no-install-recommends -o Dpkg::Options::="--force-confold" install systemd apt-utils && rm -rf /var/lib/apt/lists/*;
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target
# Debian
# CMD ["/lib/systemd/systemd"]
# Ubuntu
CMD ["/sbin/init"]
# next two lines are only for docker podman use --volume to mount
# RUN mkdir -p /home/build/
# COPY . /home/build/libreswan
# NO v6 magic interference yet.
RUN echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
RUN echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
RUN apt-get update && apt-get -o Dpkg::Options::="--force-confold" --no-install-recommends -y install \
	apt-src apt-utils bash-completion dns-root-data devscripts \
	equivs git iproute2 less locales openssh-server vim screen wget && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/^# deb-src/deb-src/' /etc/apt/sources.list && apt-get update
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
RUN cd /home/build/libreswan; make install-deb-dep && cd /
STOPSIGNAL SIGRTMIN+3
