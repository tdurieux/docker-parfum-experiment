# "Runtime" container for mirage-unix runner.

FROM debian:jessie
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
        --no-install-recommends \
        libcap-ng0 \
        libnl-3-200 \
        libnl-route-3-200 \
        qemu-system-x86 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD runner-debian.tar.gz /runtime/

# Should be set explicitly downstream.
ENTRYPOINT []
CMD []
