FROM multiarch/debian-debootstrap:armhf-buster-slim

ARG PFCLIENT_VERSION
ARG PFCLIENT_HASH

# Find the lastest version @ https://planefinder.net/sharing/client
# With the changelog @ https://planefinder.net/sharing/client_changelog
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates iputils-ping libc-bin libc-dbg && \
    curl -f --output pfclient.tar.gz "https://client.planefinder.net/pfclient_${PFCLIENT_VERSION}_armhf.tar.gz" && \
    md5sum pfclient.tar.gz && echo "${PFCLIENT_HASH}  pfclient.tar.gz" | md5sum -c && \
    tar -xvf pfclient.tar.gz && \
    mv pfclient /usr/local/bin/pfclient && \
    rm pfclient.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY pfclient-runner.sh /usr/local/bin/pfclient-runner
COPY pfclient-config.json /etc/pfclient-config.json

EXPOSE 30053

HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 CMD curl --fail http://localhost:30053/ || exit 1

ENTRYPOINT ["pfclient-runner"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="thebigguy.co.uk@gmail.com" \
      org.label-schema.name="Docker ADS-B - planefinder" \
      org.label-schema.description="Docker container for ADS-B - This is the planefinder.net component" \
      org.label-schema.url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.schema-version="1.0"
