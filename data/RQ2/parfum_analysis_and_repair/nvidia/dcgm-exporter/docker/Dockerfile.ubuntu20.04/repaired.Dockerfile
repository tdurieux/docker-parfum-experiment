ARG GOLANG_VERSION
FROM golang:$GOLANG_VERSION AS builder
WORKDIR /go/src/github.com/NVIDIA/dcgm-exporter

COPY . .

RUN make binary check-format

FROM nvcr.io/nvidia/cuda:11.6.2-base-ubuntu20.04
LABEL io.k8s.display-name="NVIDIA DCGM Exporter"

COPY --from=builder /go/src/github.com/NVIDIA/dcgm-exporter/cmd/dcgm-exporter/dcgm-exporter /usr/bin/
COPY etc /etc/dcgm-exporter

ARG DCGM_VERSION
RUN apt-get update && apt-get install -y --no-install-recommends \
    datacenter-gpu-manager=1:${DCGM_VERSION} libcap2-bin && apt-get purge --autoremove -y openssl && rm -rf /var/lib/apt/lists/*;

# Required for DCP metrics
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,compat32
# disable all constraints on the configurations required by NVIDIA container toolkit
ENV NVIDIA_DISABLE_REQUIRE="true"
ENV NVIDIA_VISIBLE_DEVICES=all

ENV NO_SETCAP=
COPY docker/dcgm-exporter-entrypoint.sh /usr/local/dcgm/dcgm-exporter-entrypoint.sh
RUN chmod +x /usr/local/dcgm/dcgm-exporter-entrypoint.sh

ENTRYPOINT ["/usr/local/dcgm/dcgm-exporter-entrypoint.sh"]
