ARG BASE_IMAGE=ghcr.io/tinyzimmer/kvdi:app-base-latest
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install --no-install-recommends -y curl libxss1 libnss3 \
    && curl -f -JL -o /usr/local/bin/Lens \
        https://github.com/lensapp/lens/releases/download/v4.0.8/Lens-4.0.8.AppImage \
    && chmod +x /usr/local/bin/Lens \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY lens.conf /etc/supervisor/conf.d/lens.conf