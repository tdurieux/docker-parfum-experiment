# FROM fedora:27
# MAINTAINER "Antony Antony" <antony@phenome.org>
# ENV container docker
RUN dnf update -y
# RUN mkdir -p /home/build/libreswan
RUN mkdir -p /home/build/
# next line for docker not for podman
# COPY . /home/build/libreswan
RUN dnf install -y systemd; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
# these first. If install breaks docker image will start, can debug.
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
RUN dnf install -y dnf-plugins-core git iproute openssh-server openssh-clients \
	python3-pexpect sudo vim-enhanced wget
RUN dnf install -y @development || dnf install -y @development-tools
# F28 and later to support X509 Certificates, signed with SHA1
RUN ls -l /usr/bin/update-crypto-policies && /usr/bin/update-crypto-policies --set LEGACY || true
# F33 does does not have directory by default.
RUN mkdir -p /etc/sysconfig/network-scripts/
RUN echo "Do not add files here.  networking is handled by systemd-networkd in\n/etc/systemd/network\networkctl" > /etc/sysconfig/network-scripts/README.libreswan
RUN ls
RUN cd /home/build/libreswan; ls; make SUDO_CMD= install-rpm-build-dep && cd /
RUN rm -fr /etc/sysconfig/network-scripts/ifcfg-ens3
# RUN /home/build/libreswan/testing/guestbin/swan-transmogrify