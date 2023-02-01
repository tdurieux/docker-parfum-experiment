FROM opensuse/leap:15.3
RUN sed -i -s 's/^# rpm.install.excludedocs/rpm.install.excludedocs/' /etc/zypp/zypp.conf && \
    sed -i 's/download/provo-mirror/g' /etc/zypp/repos.d/*repo
RUN zypper ref
RUN zypper install -y socat net-tools-deprecated libtasn1-devel gnutls-devel libseccomp-devel json-glib-devel system-user-tss git
RUN zypper install -y autoconf
RUN zypper install -y automake
RUN git clone https://github.com/stefanberger/swtpm.git /usr/src/swtpm
RUN zypper install -y libtool
RUN zypper install -y gcc
RUN zypper install -y libopenssl-devel
RUN git clone https://github.com/stefanberger/libtpms.git /usr/src/libtpms
RUN zypper install -y gcc-c++
RUN zypper install -y make
RUN zypper install -y expect
RUN zypper install -y sudo
RUN zypper install -y bridge-utils
RUN cd /usr/src/libtpms && \
    ./autogen.sh --with-openssl --with-tpm2 && \
    make -j4 && \
    make install
RUN cd /usr/src/swtpm && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib64 --with-openssl --with-tss-user=root --with-tss-group=tss && \
    make -j4 && \
    sudo make -j4 && \
    sudo make install
RUN zypper install -y qemu-x86 qemu-arm qemu-tools
RUN zypper in -y curl
RUN zypper in -y git
RUN cd /usr/src && \
    git clone git://git.ipxe.org/ipxe.git
RUN zypper in -y xz-devel
RUN zypper in -y syslinux
RUN zypper in -y mkisofs
RUN cd /usr/src/ipxe/src && \
    sed -i 's/undef\tDOWNLOAD_PROTO_HTTPS/define\tDOWNLOAD_PROTO_HTTPS/' config/general.h && \
    sed -i 's/define OCSP_CHECK/undef\tOCSP_CHECK/' config/crypto.h && \
    make DEBUG=httpcore:3 bin/ipxe.iso && \
    mkdir -p /usr/share/ipxe/ && \
    cp bin/ipxe.iso /usr/share/ipxe/

RUN zypper in -y iproute2
RUN zypper in -y dnsmasq
RUN zypper in -y bind-utils

COPY scripts/qemu-in-container /usr/bin/
COPY scripts/startvm /usr/bin/
ENTRYPOINT ["/usr/bin/qemu-in-container"]

RUN chmod +s /usr/lib/qemu-bridge-helper
RUN echo 'allow all' > /etc/qemu/bridge.conf

VOLUME /tmp/emulated_tpm
VOLUME /image