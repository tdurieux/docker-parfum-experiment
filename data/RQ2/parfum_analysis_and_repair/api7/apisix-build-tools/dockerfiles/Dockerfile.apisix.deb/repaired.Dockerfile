ARG IMAGE_BASE="ubuntu"
ARG IMAGE_TAG="20.04"

FROM ${IMAGE_BASE}:${IMAGE_TAG}

COPY ./utils/install-common.sh /install-common.sh
COPY ./utils/determine-dist.sh /determine-dist.sh

ARG iteration="0"
ARG apisix_repo="https://github.com/apache/apisix"
ARG checkout_v
ARG IMAGE_BASE
ARG IMAGE_TAG
ARG CODE_PATH

# install dependencies
RUN /install-common.sh install_apisix_dependencies_deb

ENV checkout_v=${checkout_v}
ENV iteration=${iteration}
ENV apisix_repo=${apisix_repo}
ENV IMAGE_BASE=${IMAGE_BASE}
ENV IMAGE_TAG=${IMAGE_TAG}

COPY ${CODE_PATH} /apisix

# install apisix
RUN /install-common.sh install_apisix \
    # determine dist and write it into /tmp/dist file
    && /determine-dist.sh