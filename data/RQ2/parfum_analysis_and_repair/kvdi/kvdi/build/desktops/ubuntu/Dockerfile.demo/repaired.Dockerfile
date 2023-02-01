FROM ghcr.io/tinyzimmer/kvdi:ubuntu-xfce4-latest

RUN apt-get update && apt-get install --no-install-recommends -y \
        htop libreoffice net-tools dnsutils && rm -rf /var/lib/apt/lists/*;
