ARG IMAGE_BASE="centos"
ARG IMAGE_TAG="7"

FROM ${IMAGE_BASE}:${IMAGE_TAG}

# Note: The duplication around the rpm series dockerfile here
#       is used for reuse the container layer cache
RUN if [[ $(rpm --eval '%{centos_ver}') == "8" ]]; then \
        sed -re "s/^#?\s*(mirrorlist)/#\1/g" \
             -e "s|^#?\s*baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" \
             -i /etc/yum.repos.d/CentOS-Linux-*; \
        dnf install -y centos-release-stream; \
        dnf swap -y centos-{linux,stream}-repos; \
        dnf distro-sync -y; \
    fi

COPY ./utils/build-common.sh /tmp/build-common.sh
COPY build-apisix-base.sh /tmp/build-apisix-base.sh
COPY ./utils/determine-dist.sh /tmp/determine-dist.sh

WORKDIR /tmp

ARG VERSION
ARG IMAGE_BASE
ARG IMAGE_TAG

ENV IMAGE_BASE=${IMAGE_BASE}
ENV IMAGE_TAG=${IMAGE_TAG}
ENV version=${VERSION}

RUN ./build-common.sh build_apisix_base_rpm \
    # determine dist and write it into /tmp/dist file
    && /tmp/determine-dist.sh