FROM marketplace.gcr.io/google/debian11 as exporter-builder

ENV GOPATH /usr/local
ENV GOROOT /usr/local/go
ENV GO_VERSION 1.16
ENV PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
ENV EXPORTER_VERSION 0.10.0
ENV NOTICES_SHA256 5ebf8cba27cde6faa3e91a8b42ea26505bcdc2dc919377c7ad942632c2de0add

# Installs packages
RUN set -eux \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        govendor \
        tar \
        git \
        make \
        gcc && rm -rf /var/lib/apt/lists/*;

# Installs golang version ${GO_VERSION}
RUN set -eux \
    && curl -f -L -o /tmp/go${GO_VERSION}.linux-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" \
    && tar -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz -C ${GOPATH} && rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz

RUN set -eux \
    # Downloads source code \
    && curl -f -L -o /tmp/apache_exporter.tar.gz "https://github.com/Lusitaniae/apache_exporter/archive/v${EXPORTER_VERSION}.tar.gz" \
    && mkdir -p /usr/local/src/apache_exporter \
    && tar -xzf /tmp/apache_exporter.tar.gz --strip-components=1 -C /usr/local/src/apache_exporter && rm /tmp/apache_exporter.tar.gz

RUN set -eux \
    && mkdir -p "${GOPATH}/src/github.com/Lusitaniae/apache_exporter" \
    && cd "${GOPATH}/src/github.com/Lusitaniae/apache_exporter" \
    && tar -xzf /tmp/apache_exporter.tar.gz --strip-components=1 -C . \
    # Download binary \
    && curl -f -L -o /tmp/apache_exporter-${EXPORTER_VERSION} "https://github.com/Lusitaniae/apache_exporter/releases/download/v${EXPORTER_VERSION}/apache_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz" \
    && tar -xzf /tmp/apache_exporter-${EXPORTER_VERSION} --strip-components=1 -C . \
    && mv apache_exporter /apache_exporter \
    # Extracts licences
    && govendor license +vendor > /NOTICES \
    # Verifies checksum. Changing the checksum means changing the licenses.
    && echo "${NOTICES_SHA256}  /NOTICES" | sha256sum -c && rm /tmp/apache_exporter.tar.gz

FROM marketplace.gcr.io/google/debian11

COPY --from=exporter-builder /apache_exporter /bin/apache_exporter
COPY --from=exporter-builder /NOTICES /usr/share/apache_exporter/NOTICES
COPY --from=exporter-builder /usr/local/src/apache_exporter /usr/local/src/apache_exporter

EXPOSE 9117
ENTRYPOINT ["/bin/apache_exporter"]
