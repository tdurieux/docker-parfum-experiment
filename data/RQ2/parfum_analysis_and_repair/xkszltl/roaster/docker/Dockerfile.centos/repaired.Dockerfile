# syntax=docker/dockerfile:1

ARG LABEL_BUILD_ID='Undefined'
ARG IMAGE_REGISTRY='docker.codingcafe.org/xkszltl/roaster'
ARG IMAGE_REPO="$IMAGE_REGISTRY/centos"
ARG STAGE_PREFIX=''
# ARG STAGE_PREFIX="$IMAGE_REPO:"

FROM centos:7 AS stage-init

LABEL BUILD_ID=$LABEL_BUILD_ID

# Cache invalidation.
RUN LABEL_BUILD_ID="$LABEL_BUILD_ID"

SHELL ["/bin/bash", "-c"]

# C.UTF-8 may never be available before CentOS 8 due to glibc bug.
# https://bugzilla.redhat.com/show_bug.cgi?id=1361965
ENV LANG=en_US.UTF-8

# systemd
RUN set -xe; \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ "_$i" = '_systemd-tmpfiles-setup.service' ] || rm -f "$i"; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    truncate -s0 ~/.bash_history
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

# nvidia-docker
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib64:/usr/local/nvidia/lib:${LD_LIBRARY_PATH}
ENV NVIDIA_DRIVER_CAPABILITIES=compute,graphics,utility,video
ENV NVIDIA_VISIBLE_DEVICES=all

# Pre-installed which has been removed from docker.
RUN set -e; \
    yum makecache -y; \
    yum install -y which; \
    yum autoremove -y; \
    yum clean all; \
    rm -rf /var/cache/yum; \
    truncate -s0 ~/.bash_history

VOLUME ["/var/log"]

COPY [".", "/etc/roaster/scripts"]

FROM "$STAGE_PREFIX"stage-init AS stage-repo

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN /etc/roaster/scripts/setup.sh repo

FROM "$STAGE_PREFIX"stage-repo AS stage-font

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]

RUN /etc/roaster/scripts/setup.sh font

FROM "$STAGE_PREFIX"stage-font AS stage-pkg-stable

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN /etc/roaster/scripts/setup.sh pkg-stable

FROM "$STAGE_PREFIX"stage-pkg-stable AS stage-pkg-skip

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN /etc/roaster/scripts/setup.sh pkg-skip

FROM "$STAGE_PREFIX"stage-pkg-skip AS stage-pkg-all

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN /etc/roaster/scripts/setup.sh pkg-all
RUN /etc/roaster/scripts/setup.sh fpm firewall

FROM "$STAGE_PREFIX"stage-pkg-all AS stage-auth

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN /etc/roaster/scripts/setup.sh auth vim tmux

FROM "$STAGE_PREFIX"stage-auth AS stage-tex

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN /etc/roaster/scripts/setup.sh tex

FROM "$STAGE_PREFIX"stage-tex AS stage-ss

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=secret,id=env-cred-usr,target=/etc/roaster/scripts/cred/env-cred-usr.sh,mode=500 \
    /etc/roaster/scripts/setup.sh ss

FROM "$STAGE_PREFIX"stage-ss AS stage-intel

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh intel

FROM "$STAGE_PREFIX"stage-intel AS stage-infra

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh lz4 zstd cmake hiredis ccache c-ares axel ipt cuda ucx ompi

FROM "$STAGE_PREFIX"stage-infra AS stage-llvm

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh llvm-gcc llvm-clang

FROM "$STAGE_PREFIX"stage-llvm AS stage-util

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh boost jemalloc eigen openblas gtest benchmark gflags glog snappy protobuf nsync

FROM "$STAGE_PREFIX"stage-util AS stage-misc

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh catch2 jsoncpp rapidjson simdjson utf8proc pugixml pybind grpc libpng libgdiplus mkl-dnn opencv leveldb rocksdb lmdb

FROM "$STAGE_PREFIX"stage-misc AS stage-dl

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh onnx pytorch torchvision apex

FROM "$STAGE_PREFIX"stage-dl AS stage-ort

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh ort

FROM "$STAGE_PREFIX"stage-ort AS stage-edit

LABEL BUILD_ID=$LABEL_BUILD_ID
COPY [".", "/etc/roaster/scripts"]

# Drop mirrors used in build.
RUN set -e; \
    rm -rf ~/.m2/settings.xml;

RUN updatedb

FROM "$IMAGE_REPO:breakpoint" AS resume

COPY [".", "/etc/roaster/scripts"]
RUN --mount=type=cache,id=roaster-centos7-ccache,target=/root/.ccache,mode=0755 /etc/roaster/scripts/setup.sh

FROM stage-edit