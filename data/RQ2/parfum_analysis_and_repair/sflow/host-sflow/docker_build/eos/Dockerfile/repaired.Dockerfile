FROM sysbot/fedora14-i386
RUN echo "UPDATE" && yum -y update
RUN echo "DEVTOOLS" && yum -y groupinstall "Development Tools"
RUN echo "EXTRAS" && yum -y install \
      git \
      libpcap-devel \
      libvirt-devel \
      libnfnetlink-devel \
      libxml2-devel \
      rpm-build \
      dbus-devel \
      openssl-devel && rm -rf /var/cache/yum
RUN mkdir /packages && chown 777 /packages
COPY build_hsflowd /root/build_hsflowd
ENTRYPOINT ["/root/build_hsflowd"]
