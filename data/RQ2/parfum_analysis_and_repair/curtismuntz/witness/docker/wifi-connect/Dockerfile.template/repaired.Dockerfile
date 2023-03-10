# From https://github.com/balena-io/wifi-connect/blob/master/Dockerfile.template
FROM resin/%%RESIN_MACHINE_NAME%%-debian

ENV INITSYSTEM on

RUN apt-get update \
    && apt-get install --no-install-recommends -y dnsmasq wireless-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN curl -f https://api.github.com/repos/balena-io/wifi-connect/releases/latest -s \
    | grep -hoP 'browser_download_url": "\K.*%%RESIN_ARCH%%\.tar\.gz' \
    | xargs -n1 curl -Ls \
    | tar -xvz -C /usr/src/app/

COPY start.sh .

CMD ["bash", "start.sh"]
