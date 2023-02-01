FROM debian:bullseye-slim

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt upgrade -y \
    && apt install --no-install-recommends -y \
    curl \
    netcat-traditional \
    ucspi-tcp \
    psutils \
    bash && rm -rf /var/lib/apt/lists/*;

RUN groupadd -g 2000 skia \
    && useradd -u 2000 -g 2000 skia \
    && mkdir -p /home/skia \
    && chown -R skia:skia /home/skia

COPY . /

USER skia

ENTRYPOINT ["/usr/local/bin/thanos"]