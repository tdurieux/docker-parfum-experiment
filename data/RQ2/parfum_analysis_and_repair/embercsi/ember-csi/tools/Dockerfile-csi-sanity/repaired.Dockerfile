FROM scratch
ARG VERSION=2.2.0
ADD csi-sanity-v${VERSION} /csi-sanity
ENTRYPOINT ["/csi-sanity"]