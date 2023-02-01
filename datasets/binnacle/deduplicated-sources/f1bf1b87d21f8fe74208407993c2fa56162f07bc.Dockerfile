FROM nvidia/cuda:8.0-devel-ubuntu16.04 as build

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        ca-certificates \
        wget \
        cuda-cudart-dev-8-0 \
        cuda-misc-headers-8-0 \
        cuda-nvml-dev-8-0 && \
    rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.10.2
RUN wget -nv -O - https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    | tar -C /usr/local -xz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

ENV CGO_CFLAGS "-I /usr/local/cuda-8.0/include"
ENV CGO_LDFLAGS "-L /usr/local/cuda-8.0/lib64"
ENV PATH=$PATH:/usr/local/nvidia/bin:/usr/local/cuda/bin

WORKDIR /go/src/deepomatic-shared-gpu-nvidia-device-plugin
COPY . .

RUN export CGO_LDFLAGS_ALLOW='-Wl,--unresolved-symbols=ignore-in-object-files' && \
    go install -ldflags="-s -w" -v deepomatic-shared-gpu-nvidia-device-plugin


FROM debian:stretch-slim

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=utility

COPY --from=build /go/bin/deepomatic-shared-gpu-nvidia-device-plugin /usr/bin/deepomatic-shared-gpu-nvidia-device-plugin

CMD ["deepomatic-shared-gpu-nvidia-device-plugin"]
