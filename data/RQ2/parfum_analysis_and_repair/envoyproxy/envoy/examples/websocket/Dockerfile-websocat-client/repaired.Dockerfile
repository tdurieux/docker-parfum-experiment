FROM solsson/websocat@sha256:902f0b3a263fd274fc1acf24e95c7226071075b42775894205285fd894188120

ENV DEBIAN_FRONTEND=noninteractive

ADD interact.sh /interact.sh
RUN chmod +x /interact.sh

RUN apt-get -qq update \
    && apt-get -qq install -qq --no-install-recommends -y expect \
    && apt-get -qq autoremove -y && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*


ENTRYPOINT ["/interact.sh"]