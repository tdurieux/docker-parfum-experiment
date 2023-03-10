FROM golang:1.15

COPY scripts/devtools.sh /opt/devtools.sh

RUN set -e -x \
    && /opt/devtools.sh
ENV PATH=/go/bin:$PATH

# install mkdocs
RUN set -ex \
    && buildDeps=' \
        build-essential \
        python3-dev \
    ' \
    && apt-get update && apt-get install -y --no-install-recommends \
        $buildDeps \
        python3 \
        python3-setuptools \
        python3-wheel \
        python3-pip \
    && pip3 install --no-cache-dir --upgrade \
        pip \
        'Markdown>=2.6.9' \
        'mkdocs>=0.16.3' \
        'mkdocs-material>=1.10.1' \
        'markdown-include>=0.5.1' \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

ENV CGO_ENABLED 0
ENV GOPATH /go:/yq
