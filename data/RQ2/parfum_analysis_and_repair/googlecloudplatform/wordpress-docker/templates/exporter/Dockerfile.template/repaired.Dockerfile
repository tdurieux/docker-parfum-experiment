FROM {{ .From }} as exporter-builder

{{- $apache_exporter := index .Packages "apache_exporter" }}
{{- $golang := index .Packages "golang" }}
{{- $template := index .TemplateArgs }}

ENV GOPATH /usr/local
ENV GOROOT /usr/local/go
ENV GO_VERSION {{ $golang.Version }}
ENV PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
ENV EXPORTER_VERSION {{ $apache_exporter.Version }}
ENV NOTICES_SHA256 {{ $template.exporter_notices_check_sum }}

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

FROM {{ .From }}

COPY --from=exporter-builder /apache_exporter /bin/apache_exporter
COPY --from=exporter-builder /NOTICES /usr/share/apache_exporter/NOTICES
COPY --from=exporter-builder /usr/local/src/apache_exporter /usr/local/src/apache_exporter

EXPOSE 9117
ENTRYPOINT ["/bin/apache_exporter"]
