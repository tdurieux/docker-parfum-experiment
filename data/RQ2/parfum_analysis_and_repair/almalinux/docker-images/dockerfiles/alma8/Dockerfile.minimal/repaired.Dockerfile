ARG SYSBASE=almalinux/8-base
FROM ${SYSBASE} as builder

RUN mkdir /mnt/sysimage; \
    dnf install \
    --installroot /mnt/sysimage \
    --releasever 8 \
    --setopt install_weak_deps=false \
    --nodocs -y \
    coreutils-single \
    glibc-minimal-langpack \
    microdnf \
    rootfiles; \
    dnf --installroot /mnt/sysimage clean all; \
    rm -rf /mnt/sysimage/var/log/dnf* /mnt/sysimage/var/log/yum.*; \
    rm -rf /mnt/sysimage/var/lib/dnf/history* /var/log/hawkey.log  /mnt/sysimage/boot /mnt/sysimage/dev/null /mnt/sysimage/run/*; \
    mkdir -p /mnt/sysimage/run/lock; \
    # rm -rf /mnt/sysimage/var/cache/*  removed line
    # cp /etc/yum.repos.d/*.repo /mnt/sysimage/etc/yum.repos.d/; \
    # generate build time file for compatibility with CentOS
    /bin/date +%Y%m%d_%H%M > /mnt/sysimage/etc/BUILDTIME; \
    echo '%_install_langs C.utf8' > /mnt/sysimage/etc/rpm/macros.image-language-conf; \
    echo 'LANG="C.utf8"' >  /mnt/sysimage/etc/locale.conf; \
    echo 'container' > /mnt/sysimage/etc/dnf/vars/infra; \
    rm -f /mnt/sysimage/etc/machine-id; \
    touch /mnt/sysimage/etc/machine-id;

# Almalinux minimal build
FROM scratch 
COPY --from=builder /mnt/sysimage/ /

CMD ["/bin/bash"]