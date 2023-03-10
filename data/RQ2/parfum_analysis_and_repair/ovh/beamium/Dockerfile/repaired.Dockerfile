FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive
ARG METRICS_APT_URL=http://last.public.ovh.metrics.snap.mirrors.ovh.net
RUN useradd -u 1000 beamium
RUN apt-get update \
        && apt-get install --no-install-recommends -y apt-transport-https curl gnupg gettext-base ca-certificates \
        && echo "deb $METRICS_APT_URL/debian stretch main" >> /etc/apt/sources.list.d/beamium.list \
        && curl -f https://last-public-ovh-metrics.snap.mirrors.ovh.net/pub.key | apt-key add - \
        && apt-get update \
        && apt-get install --no-install-recommends -y beamium \
        && rm -rf /var/lib/apt/lists/* \
        && chown -R beamium:beamium /etc/beamium/
USER 1000
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["beamium"]
