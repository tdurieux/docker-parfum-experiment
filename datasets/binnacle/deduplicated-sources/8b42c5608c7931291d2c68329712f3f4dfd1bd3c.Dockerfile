# Clone from the Fedora 22 image
FROM fedora:25

RUN dnf install -y krb5-libs krb5-server krb5-workstation libev
RUN dnf install -y gnutls gnutls-utils protobuf-c iproute pcllib http-parser tcp_wrappers pam systemd libseccomp
RUN dnf install -y bash net-tools nuttcp iputils openssh-clients
RUN dnf install -y libnl3 libtalloc libev
RUN dnf install -y lz4 radcli liboauth oathtool procps-ng iputils
RUN dnf install -y freeradius-client
RUN dnf install -y pam_krb5

# To be able to debug
RUN dnf install -y openssh-server strace lsof && dnf clean all
RUN echo 'root:root' | chpasswd
RUN echo set -o vi >> /etc/bashrc

RUN mkdir -p /etc/ocserv
RUN mkdir -p /tmp/disconnect/

ADD krb5.conf /etc/
ADD kdc.conf /var/kerberos/krb5kdc/
ADD k5.KERBEROS.TEST /var/kerberos/krb5kdc/
ADD kadm5.acl /var/kerberos/krb5kdc/

RUN echo -e "secret123\nsecret123"|/usr/sbin/kdb5_util create -s
RUN echo -e "testuser123\ntestuser123" | /usr/sbin/kadmin.local -q "addprinc testuser"
RUN echo -e "test123\ntest123" | /usr/sbin/kadmin.local -q "addprinc HTTP/kerberos.test"
RUN /usr/sbin/kadmin.local -q "xst -norandkey -k /etc/krb5-keytab HTTP/kerberos.test@KERBEROS.TEST"
RUN useradd testuser

ADD key.pem /etc/ocserv/
ADD cert.pem /etc/ocserv/
ADD ocserv.conf /etc/ocserv/
ADD passwd /etc/ocserv/
ADD myscript /usr/bin/
# It's not possible to use mknod inside a container with the default LXC
# template, so we untar it from this archive.
ADD dev-tun.tgz /dev/
ADD pam-ocserv /etc/pam.d/ocserv

ADD ocserv /usr/sbin/
ADD ocpasswd /usr/bin/
ADD occtl /usr/bin/

CMD nuttcp -S;/usr/sbin/krb5kdc;sshd-keygen;/usr/sbin/sshd;/usr/sbin/ocserv -d 1 -f;sleep 3600
