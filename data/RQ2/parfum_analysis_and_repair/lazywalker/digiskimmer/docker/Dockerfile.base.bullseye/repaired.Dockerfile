FROM debian:bullseye-slim as builder

LABEL maintainer="Michael BD7MQB <bd7mqb@qq.com>"

ARG APT=
RUN if [ "${APT}" != "" ] ; then \
    sed -i "s/deb.debian.org/${APT}/g" /etc/apt/sources.list && \
    sed -i "s/security.debian.org/${APT}/g" /etc/apt/sources.list \
    ; fi

RUN apt-get update && \
    apt-get install -y --no-install-recommends wsjtx=2.2.2+repack-2 && rm -rf /var/lib/apt/lists/*;

FROM debian:bullseye-slim

ARG APT=
RUN if [ "${APT}" != "" ] ; then \
    sed -i "s/deb.debian.org/${APT}/g" /etc/apt/sources.list && \
    sed -i "s/security.debian.org/${APT}/g" /etc/apt/sources.list \
    ; fi

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libfftw3-bin libqt5core5a \
    python3 python3-numpy python3-requests && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /usr/bin/jt9 /usr/bin/
COPY --from=builder /usr/bin/wsprd /usr/bin/
