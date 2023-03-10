FROM fedora-minimal:36

RUN microdnf -y install --nodocs --setopt=install_weak_deps=0 \
                        which tar wget hostname shadow-utils socat findutils \
                        lsof bind-utils gzip procps-ng rsync iproute diffutils python3  && \
    microdnf clean all