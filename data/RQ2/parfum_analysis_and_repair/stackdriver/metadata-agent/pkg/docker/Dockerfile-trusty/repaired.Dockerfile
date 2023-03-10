FROM ubuntu:trusty

ARG package
ADD ${package} /stackdriver-metadata.deb
RUN apt-get update \
    && ( dpkg -i /stackdriver-metadata.deb || true) \
    && apt-get install --no-install-recommends -f -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /stackdriver-metadata.deb

CMD /opt/stackdriver/metadata/sbin/metadatad

EXPOSE 8000
