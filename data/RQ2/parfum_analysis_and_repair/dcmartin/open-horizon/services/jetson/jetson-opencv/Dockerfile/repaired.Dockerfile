ARG BUILD_FROM

FROM ${BUILD_FROM}

ARG BUILD_ARCH=arm64


###
### OPENCV
###

RUN apt-get update && apt-get install --no-install-recommends -y \
	pkg-config && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
	libavcodec-ffmpeg56 \
	libavformat-ffmpeg56 \
	libavutil-ffmpeg54 \
	libswscale-ffmpeg3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
	libcairo2 \
	libgdk-pixbuf2.0-0 \
	libgtk2.0-0 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
	libpng12-0 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
	libtbb2 \
	libglib2.0-0 \
	libjasper1 \
	libjpeg8 >=8c \
	libtbb-dev && rm -rf /var/lib/apt/lists/*;

RUN for DEB in \
	libopencv_3.3.1_t186_arm64.deb \
	libopencv-dev_3.3.1_t186_arm64.deb \
	libopencv-samples_3.3.1_t186_arm64.deb \
	libopencv-python_3.3.1_t186_arm64.deb \
	; do dpkg --install ${DEB}; done

## Clean up
RUN apt-get -y autoremove && apt-get -y autoclean
RUN rm -rf /var/cache/apt

# Environment variables
ENV \
    HOME="/root" \
    LANG="C.UTF-8" \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    TERM="xterm"

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    curl \
    socat \
    jq \

  && rm -fr \
    /tmp/* && rm -rf /var/lib/apt/lists/*;

# Copy usr
COPY rootfs /

CMD [ "/usr/bin/run.sh" ]

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.build-arch="${BUILD_ARCH}" \
    org.label-schema.name="jetson-opencv" \
    org.label-schema.description="JetsonTX with Jetpack, CUDA and OpenCV" \
    org.label-schema.vcs-url="http://github.com/dcmartin/open-horizon/tree/master/jetson-opencv" \
    org.label-schema.vcs-ref="${BUILD_REF}" \
    org.label-schema.version="${BUILD_VERSION}" \
    org.label-schema.vendor="David C Martin <github@dcmartin.com>"
