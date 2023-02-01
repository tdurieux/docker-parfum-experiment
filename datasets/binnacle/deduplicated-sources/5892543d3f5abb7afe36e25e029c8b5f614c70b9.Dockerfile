FROM fedora:25

RUN yum install -y gnutls gnutls-utils protobuf-c iproute pcllib http-parser tcp_wrappers pam systemd libseccomp
RUN yum install -y bash openssh-server nuttcp
RUN yum install -y libnl3 libtalloc libev
RUN yum install -y freeradius-client
RUN yum install -y lz4 radcli liboauth oathtool procps-ng iputils
RUN yum install -y krb5-libs less
RUN systemctl enable sshd
RUN sed 's/PermitRootLogin without-password/PermitRootLogin yes/g' -i /etc/ssh/sshd_config

RUN echo 'root:root' |chpasswd
RUN useradd -m -d /home/admin -s /bin/bash admin
RUN echo 'admin:admin' |chpasswd

RUN mkdir /etc/ocserv


ADD key.pem /etc/ocserv/
ADD cert.pem /etc/ocserv/
ADD ocserv.conf /etc/ocserv/
ADD passwd /etc/ocserv/
ADD ocserv /usr/sbin/
ADD ocpasswd /usr/bin/
ADD occtl /usr/bin/
ADD myscript /usr/bin/
# It's not possible to use mknod inside a container with the default LXC
# template, so we untar it from this archive.
ADD dev-tun.tgz /dev/

CMD nuttcp -S;sshd-keygen;/usr/sbin/sshd;mkdir -p /tmp/disconnect/;usr/sbin/ocserv -d 1 -f;sleep 3600
