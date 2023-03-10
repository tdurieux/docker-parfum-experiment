ARG SYSBASE=almalinux
FROM ${SYSBASE} as system-build

RUN mkdir /mnt/sys-root; \
    dnf install \
    --nogpgcheck --repoid=AppStream --repoid=BaseOS \
    --repofrompath='BaseOS,https://repo.almalinux.org/almalinux/9/BaseOS/$basearch/os/' \
    --repofrompath='AppStream,https://repo.almalinux.org/almalinux/9/AppStream/$basearch/os/' \
    --installroot /mnt/sys-root \
    --releasever 9 \
    --setopt install_weak_deps=false \
    --nodocs -y \
    coreutils-single \
    glibc-minimal-langpack; \
    dnf --installroot /mnt/sys-root clean all; \
    rm -rf /mnt/sys-root/var/cache/* /mnt/sys-root/var/log/dnf* /mnt/sys-root/var/log/yum.*; \
    # cp /etc/yum.repos.d/*.repo /mnt/sys-root/etc/yum.repos.d/; \
    # generate build time file for compatibility with CentOS
    /bin/date +%Y%m%d_%H%M > /mnt/sys-root/etc/BUILDTIME ;

FROM scratch

COPY --from=system-build /mnt/sys-root/ /

CMD /bin/sh