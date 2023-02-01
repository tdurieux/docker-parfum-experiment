FROM debian:bullseye as install
ARG TARGETARCH
ARG TARGETVARIANT

RUN --mount=type=cache,id=apt-build,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    apt-get update && \
    apt-get install --no-install-recommends --yes python3 libopenblas-base libgomp1 libatomic1 && rm -rf /var/lib/apt/lists/*;

RUN --mount=type=cache,id=apt-build,target=/var/cache/apt \
    if [ "${TARGETARCH}${TARGETVARIANT}" = 'armv7' ]; then \
        apt-get install --no-install-recommends --yes libatlas3-base libgfortran5; rm -rf /var/lib/apt/lists/*; \
    fi


COPY *.deb /

ENV DEBIAN_ARCH=${TARGETARCH}${TARGETVARIANT}
RUN --mount=type=cache,id=apt-build,target=/var/cache/apt \
    if [ "${DEBIAN_ARCH}" = 'armv7' ]; then export DEBIAN_ARCH='armhf'; fi && \
    apt-get install --yes --no-install-recommends ./larynx-tts_1.0.0_${DEBIAN_ARCH}.deb && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /output
RUN larynx --debug -q low 'This is a test.' > /output/bullseye_${TARGETARCH}${TARGETVARIANT}.wav

# -----------------------------------------------------------------------------

FROM scratch

COPY --from=install /output/ /
