ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Ada
WORKDIR /usr/src
ARG ADA_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        portaudio19-dev \
        libasound2-plugins \
        libsndfile1 \
        mplayer \
        libffi-dev \
        python3 \
        python3-pip \
        python3-dev \
        git \
        build-essential \
    \
    && git clone --depth 1 -b ${ADA_VERSION} \
        "https://github.com/home-assistant/ada" \
    && pip3 install --no-cache-dir -U setuptools wheel \
    && pip3 install --no-cache-dir -r ada/requirements.txt \
    && pip3 install --no-cache-dir ada/ \
    && rm -rf ada \
    \
    && apt-get purge -y --auto-remove \
        git \
        build-essential \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY rootfs /
