ARG QEMU_IMAGE=calico/go-build:latest
ARG BIRD_IMAGE=calico/bird:latest

FROM ${QEMU_IMAGE} as qemu
FROM ${BIRD_IMAGE} as bird

FROM calico/bpftool:v5.3-s390x as bpftool

FROM s390x/alpine:3.8 as base

ARG ARCH=s390x

# Enable non-native builds of this image on an amd64 hosts.
# This must be the first RUN command in this file!
# we only need this for the intermediate "base" image, so we can run all the apk and other commands
# when running on a kernel >= 4.8, this will become less relevant
COPY --from=qemu /usr/bin/qemu-s390x-static /usr/bin/

# Install remaining runtime deps required for felix from the global repository
RUN apk add --no-cache ip6tables ipset iputils iproute2 conntrack-tools runit ca-certificates

# Copy our bird binaries in
COPY --from=bird /bird* /bin/

# Copy in the filesystem - this contains felix, calico-bgp-daemon etc...
COPY filesystem/ /

# Copy in the calico-node binary
COPY dist/bin/calico-node-${ARCH} /bin/calico-node

COPY --from=bpftool /bpftool /bin

RUN rm /usr/bin/qemu-s390x-static

CMD ["start_runit"]