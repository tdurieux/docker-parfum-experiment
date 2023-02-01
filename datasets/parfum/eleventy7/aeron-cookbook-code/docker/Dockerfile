ARG REPO_NAME=docker.io/
ARG IMAGE_NAME=azul/zulu-openjdk-debian
ARG IMAGE_TAG=17
FROM ${REPO_NAME}${IMAGE_NAME}:${IMAGE_TAG}

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

COPY --chmod=755 setup-docker.sh /root/dockerbuild/setup-docker.sh
RUN /root/dockerbuild/setup-docker.sh && rm --recursive --force "/root/dockerbuild"
