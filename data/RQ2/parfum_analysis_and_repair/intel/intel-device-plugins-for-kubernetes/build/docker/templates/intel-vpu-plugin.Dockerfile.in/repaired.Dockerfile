#include "final_base.docker"
#include "golang_base.docker"

FROM ${GOLANG_BASE} as builder

#include "default_args.docker"

ARG CMD=vpu_plugin

WORKDIR $DIR
COPY . .

RUN echo "deb-src http://deb.debian.org/debian unstable main" | tee -a /etc/apt/sources.list
RUN apt update && apt -y --no-install-recommends install dpkg-dev libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /install_root/licenses/libusb \
    && cd /install_root/licenses/libusb \
    && apt-get --download-only source libusb-1.0-0 \
    && cd -
RUN cd cmd/$CMD; GO111MODULE=${GO111MODULE} CGO_ENABLED=1 go install "${BUILDFLAGS}"; cd -
RUN install -D /go/bin/vpu_plugin /install_root/usr/local/bin/intel_vpu_device_plugin

#include "default_licenses.docker"

FROM debian:unstable-slim

#include "default_labels.docker"

LABEL name='intel-vpu-plugin'
LABEL summary='Intel® VPU device plugin for Kubernetes'

RUN apt update && apt -y --no-install-recommends install libusb-1.0-0 && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /install_root /
ENTRYPOINT ["/usr/local/bin/intel_vpu_device_plugin"]



