FROM registry.fedoraproject.org/fedora-minimal:34
COPY _out/hostpath-csi-driver /
ENTRYPOINT ["/hostpath-csi-driver"]