FROM ghcr.io/cross-rs/x86_64-unknown-linux-gnu:main-centos

RUN yum -y update && \
    yum -y install centos-release-scl && \
    yum-config-manager --enable rhel-server-rhscl-8-rpms && \
    yum -y install llvm-toolset-7.0 && rm -rf /var/cache/yum

COPY centos-entrypoint /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
