FROM multiarch/debian-debootstrap:armhf-buster-slim

ARG FR24FEED_VERSION
ARG FR24FEED_HASH

# Find the laest version @ http://repo.feed.flightradar24.com/ searching for "rpi_binaries/fr24feed_*_armhf.tgz"
# With the changelog @ http://repo.feed.flightradar24.com/CHANGELOG.md
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates iputils-ping dnsutils && \
    curl -f --output fr24feed.tgz "https://repo.feed.flightradar24.com/rpi_binaries/fr24feed_${FR24FEED_VERSION}_armhf.tgz" && \
    sha256sum fr24feed.tgz && echo "${FR24FEED_HASH}  fr24feed.tgz" | sha256sum -c && \
    tar -xvf fr24feed.tgz --strip-components=1 fr24feed_armhf/fr24feed && \
    mv fr24feed /usr/bin/fr24feed && \
    rm fr24feed.tgz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# https://feed.flightradar24.com/fr24feed-manual.pdf
COPY fr24feed.ini /etc/fr24feed.ini
COPY fr24feed-runner.sh /usr/bin/fr24feed-runner

EXPOSE 8754/tcp

HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 CMD curl --fail http://localhost:8754/ || exit 1

ENTRYPOINT ["fr24feed-runner"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="thebigguy.co.uk@gmail.com" \
      org.label-schema.name="Docker ADS-B - flightradar24" \
      org.label-schema.description="Docker container for ADS-B - This is the flightradar24.com component" \
      org.label-schema.url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.schema-version="1.0"
