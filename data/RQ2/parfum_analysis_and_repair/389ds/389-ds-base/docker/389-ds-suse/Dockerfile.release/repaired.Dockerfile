#!BuildTag: 389-ds-container
FROM opensuse/leap:15.1
MAINTAINER wbrown@suse.de

EXPOSE 3389 3636

# RUN zypper ar -G obs://network:ldap network:ldap && \
RUN zypper ar http://download.opensuse.org/update/leap/15.1/oss/ u && \
    zypper ar http://download.opensuse.org/distribution/leap/15.1/repo/oss/ m && \
    zypper ar http://download.opensuse.org/repositories/network:ldap/openSUSE_Leap_15.1/ "network:ldap" && \
    zypper mr -p 97 "network:ldap" && \
    zypper --gpg-auto-import-keys ref

# Push source code to the container - we do this early because we want the zypper and 
# build instructions in a single RUN stanza to minimise the container final size.
ADD ./ /usr/local/src/389-ds-base
WORKDIR /usr/local/src/389-ds-base


# Build and install
# Derived from rpm --eval '%configure' on opensuse.

RUN zypper --non-interactive si --build-deps-only 389-ds && \
    zypper in -y 389-ds rust cargo rust-std && \
    zypper rm -y 389-ds lib389 && \
    autoreconf -fiv && \
    ./configure --host=x86_64-suse-linux-gnu --build=x86_64-suse-linux-gnu \
    --program-prefix= \
    --disable-dependency-tracking \
    --prefix=/usr \
    --exec-prefix=/usr \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --sysconfdir=/etc \
    --datadir=/usr/share \
    --includedir=/usr/include \
    --libdir=/usr/lib64 \
    --libexecdir=/usr/lib \
    --localstatedir=/var \
    --sharedstatedir=/var/lib \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info \
    --disable-dependency-tracking \
    --enable-gcc-security --enable-autobind --enable-auto-dn-suffix --with-openldap \
    --enable-rust --disable-perl --with-pythonexec="python3" --without-systemd \
    --libexecdir=/usr/lib/dirsrv/ --prefix=/ && \
    make -j 12 && \
    make install && \
    make lib389 && \
    make lib389-install && \
    make clean && \
    zypper rm -y -u rust cargo rust-std gcc gcc-c++ automake autoconf

# Link some known static locations to point to /data
RUN mkdir -p /data/config && \
    mkdir -p /data/ssca && \
    mkdir -p /data/run && \
    mkdir -p /var/run/dirsrv && \
    ln -s /data/config /etc/dirsrv/slapd-localhost && \
    ln -s /data/ssca /etc/dirsrv/ssca && \
    ln -s /data/run /var/run/dirsrv

# Temporal volumes for each instance

VOLUME /data

# Set the userup correctly. This was created as part of the 389ds in above.
# For k8s we'll need 389 to not drop privs? I think we don't specify a user
# here and ds should do the right thing if a non root user runs the server.
# USER dirsrv