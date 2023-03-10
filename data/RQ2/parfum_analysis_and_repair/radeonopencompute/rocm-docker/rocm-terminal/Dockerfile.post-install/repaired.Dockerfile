#| This Dockerfile provides a compatibility check for ROCm docker container.
ARG base_image
FROM ${base_image}

MAINTAINER Peng Sun <peng.sun@amd.com>

COPY scripts/compatibility-check.sh /opt/rocm/bin/rocm-compatibility-test.sh
RUN sudo chmod a+x /opt/rocm/bin/rocm-compatibility-test.sh
ENTRYPOINT ["/opt/rocm/bin/rocm-compatibility-test.sh"]

# Default to a login shell