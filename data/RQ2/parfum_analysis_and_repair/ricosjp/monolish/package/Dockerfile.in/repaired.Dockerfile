FROM ${MONOLISH_CONTAINER_BASE_IMAGE}:${MONOLISH_CONTAINER_BASE_TAG}

RUN apt-get update -y \
 && apt-get install --no-install-recommends -y python3-pip \
 && apt-get clean && \
 pip3 install --no-cache-dir monolish-log-viewer==0.1.1 && rm -rf /var/lib/apt/lists/*;

COPY monolish_common_${monolish_package_version}.deb /
RUN apt install --no-install-recommends -y /monolish_common_${monolish_package_version}.deb \
 && rm /monolish_common_${monolish_package_version}.deb && rm -rf /var/lib/apt/lists/*;

COPY ${CPACK_DEBIAN_FILE_NAME} /
RUN apt install --no-install-recommends -y /${CPACK_DEBIAN_FILE_NAME} \
 && rm ${CPACK_DEBIAN_FILE_NAME} && rm -rf /var/lib/apt/lists/*;

#
# Annotations based on OCI specification
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#
LABEL maintainer="RICOS Co. Ltd." \
  org.opencontainers.image.vendor="RICOS Co. Ltd." \
  org.opencontainers.image.description="monolish: MONOlithic LInear equation Solvers for Highly-parallel architecture" \
  org.opencontainers.image.source="https://github.com/ricosjp/monolish" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.version="${monolish_package_version}" \
  org.opencontainers.image.revision="${git_hash}" \
  org.opencontainers.image.created="${build_date}"
