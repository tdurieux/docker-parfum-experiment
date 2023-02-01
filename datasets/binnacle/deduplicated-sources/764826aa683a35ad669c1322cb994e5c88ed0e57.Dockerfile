FROM debian:stretch

RUN apt-get update -y
RUN apt-get install -y haproxy libgnutls30 libprotobuf-c1 liboath0 libev4
RUN apt-get install -y libwrap0 libpam0g libseccomp2 libdbus-1-3 libreadline5 libnl-route-3-200
RUN apt-get install -y libhttp-parser2.1 libpcl1 libopts25 autogen
RUN apt-get install -y libsystemd0 valgrind nuttcp openssh-server bash
RUN apt-get install -y libtalloc2 libradcli4 libkrb5-3 less liblz4-1
RUN sed 's/PermitRootLogin without-password/PermitRootLogin yes/g' -i /etc/ssh/sshd_config

RUN echo 'root:root' |chpasswd
RUN useradd -m -d /home/admin -s /bin/bash admin
RUN echo 'admin:admin' |chpasswd

RUN mkdir /etc/ocserv


ADD key.pem /etc/ocserv/
ADD cert.pem /etc/ocserv/
ADD combo.pem /etc/ocserv/
ADD haproxy.cfg /etc/haproxy/
ADD ocserv-unix.conf /etc/ocserv/ocserv.conf
ADD passwd /etc/ocserv/
ADD ocserv /usr/sbin/
ADD ocpasswd /usr/bin/
ADD occtl /usr/bin/
ADD myscript /usr/bin/
# It's not possible to use mknod inside a container with the default LXC
# template, so we untar it from this archive.
ADD dev-tun.tgz /dev/

CMD nuttcp -S;/etc/init.d/ssh restart;mkdir -p /tmp/disconnect/;/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg;/usr/sbin/ocserv -d 1 -f;sleep 3600
