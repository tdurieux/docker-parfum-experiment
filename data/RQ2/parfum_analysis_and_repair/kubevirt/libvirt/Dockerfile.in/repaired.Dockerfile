FROM fedora:@FEDORA_VERSION@

LABEL maintainer="The KubeVirt Project <kubevirt-dev@googlegroups.com>"

RUN dnf install -y dnf-plugins-core && \
    dnf copr enable -y @kubevirt/libvirt-@LIBVIRT_SOURCE_VERSION@ && \
    dnf copr enable -y @kubevirt/qemu-kvm-@QEMU_SOURCE_VERSION@ && \
    dnf copr enable -y @kubevirt/seabios-@SEABIOS_SOURCE_VERSION@ && \
    dnf install -y \
        libvirt-daemon-driver-qemu-@LIBVIRT_BINARY_VERSION@ \
        libvirt-client-@LIBVIRT_BINARY_VERSION@ \
        libvirt-daemon-driver-storage-core-@LIBVIRT_BINARY_VERSION@ \
        qemu-kvm-@QEMU_BINARY_VERSION@ \
        seabios-bin-@SEABIOS_BINARY_VERSION@ \
        seavgabios-bin-@SEABIOS_BINARY_VERSION@ \
        xorriso \
        selinux-policy selinux-policy-targeted \
        nftables \
        iptables \
        procps-ng \
        findutils \
        augeas && \
    dnf update -y libgcrypt && \
    dnf clean all && \
    for qemu in \
        /usr/bin/qemu-system-aarch64 \
        /usr/bin/qemu-system-ppc64 \
        /usr/bin/qemu-system-s390x \
        /usr/bin/qemu-system-x86_64 \
        /usr/libexec/qemu-kvm; \
    do \
        test -f "$qemu" || continue; \
        # Allow qemu to bind to privileged ports \
        # From: https://github.com/kubevirt/kubevirt/pull/1138 \
        setcap CAP_NET_BIND_SERVICE=+eip "$qemu" && \
        break; \
    done

COPY augconf /augconf
RUN augtool -f /augconf