#include "final_base.docker"
#include "golang_base.docker"

FROM ${GOLANG_BASE} as builder

#include "default_args.docker"

#define _ENTRYPOINT_ /usr/local/bin/intel_sgx_device_plugin
ARG EP=_ENTRYPOINT_
ARG CMD=qat_plugin

WORKDIR $DIR
COPY . .

ARG QAT_DRIVER_RELEASE="qat1.7.l.4.14.0-00031"
ARG QAT_DRIVER_SHA256="a68dfaea4308e0bb5f350b7528f1a076a0c6ba3ec577d60d99dc42c49307b76e"

RUN mkdir -p /usr/src/qat \
    && cd /usr/src/qat  \
    && wget https://downloadmirror.intel.com/30178/eng/$QAT_DRIVER_RELEASE.tar.gz \
    && echo "$QAT_DRIVER_SHA256  $QAT_DRIVER_RELEASE.tar.gz" | sha256sum -c - \
    && tar xf *.tar.gz \
    && cd /usr/src/qat/quickassist/utilities/adf_ctl \
    && make KERNEL_SOURCE_DIR=/usr/src/qat/quickassist/qat \
    && install -D adf_ctl /install_root/usr/local/bin/adf_ctl && rm -rf /usr/src/qat
RUN cd cmd/$CMD; GO111MODULE=${GO111MODULE} CGO_ENABLED=1 go install -tags kerneldrv; cd -
RUN chmod a+x /go/bin/$CMD \
    && install -D /go/bin/$CMD /install_root/usr/local/bin/intel_qat_device_plugin

#include "default_licenses.docker"   


FROM debian:unstable-slim

#include "default_labels.docker"

LABEL name='intel-qat-plugin-kerneldrv'
LABEL summary='Intel® QAT device plugin kerneldrv for Kubernetes'

COPY --from=builder /install_root /
ENV PATH=/usr/local/bin
ENTRYPOINT ["/usr/local/bin/intel_qat_device_plugin"]
