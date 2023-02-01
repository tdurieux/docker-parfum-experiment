# syntax=docker/dockerfile:1
# ARG YP_DOCKER_CI_FROM
# FROM ${YP_DOCKER_CI_FROM}
FROM ubuntu:16.04

# keep in sync with dockerfiles/yp-ubuntu-*/Dockerfile

ARG YP_CI_BREW_INSTALL
ARG YP_DOCKER_CI_IMAGE_NAME
ARG YP_OS_RELEASE_DIR

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

COPY . /yplatform

RUN cp -Rp -L /yplatform/${YP_OS_RELEASE_DIR}/Dockerfile.test.sh /Dockerfile.test.sh
# see https://www.camptocamp.com/en/news-events/flexible-docker-entrypoints-scripts
# see https://github.com/camptocamp/docker-git/blob/master/docker-entrypoint.sh
RUN cp -Rp -L /yplatform/${YP_OS_RELEASE_DIR}/Dockerfile.entrypoint.sh /Dockerfile.entrypoint.sh
RUN cp -Rp -L /yplatform/${YP_OS_RELEASE_DIR}/Dockerfile.entrypoint.d /Dockerfile.entrypoint.d
# ONBUILD COPY Dockerfile.entrypoint.d/* /Dockerfile.entrypoint.d/
# ONBUILD COPY docker-entrypoint.d/* /Dockerfile.entrypoint.d/ # ?! compat with camptocamp
ENTRYPOINT ["/Dockerfile.entrypoint.sh"]

RUN YP_DOCKER_CI_IMAGE_NAME=${YP_DOCKER_CI_IMAGE_NAME} \
  YP_CI_BREW_INSTALL=${YP_CI_BREW_INSTALL} \
  /yplatform/.codeship/$(source /etc/os-release && echo "${ID}-${VERSION_ID}")/Dockerfile.build.sh

CMD ["bash"]

COPY . /home/codeship/build
RUN chown -R codeship:codeship /home/codeship/build

USER codeship
WORKDIR /home/codeship/build
