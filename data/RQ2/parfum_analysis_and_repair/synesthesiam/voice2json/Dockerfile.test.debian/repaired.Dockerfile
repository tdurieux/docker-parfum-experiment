FROM ubuntu:eoan as base

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 dpkg-dev \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        perl sox alsa-utils espeak jq && rm -rf /var/lib/apt/lists/*;

COPY dist/ /dist/
COPY VERSION /

RUN export DEBIAN_ARCH="$(dpkg-architecture | grep DEB_BUILD_ARCH= | sed -e 's/[^=]\+=//')" && \
    export VERSION="$(cat ${BUILD_DIR}/VERSION)" && \
    cd /dist && \
    apt install -y --no-install-recommends ./voice2json_${VERSION}_${DEBIAN_ARCH}.deb && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["voice2json"]