ARG IMAGE_REPO
FROM ${IMAGE_REPO:-lagoon}/commons as commons
FROM golang:alpine as golang

RUN apk add --no-cache git
RUN go get github.com/a8m/envsubst/cmd/envsubst

FROM docker:stable

LABEL maintainer="amazee.io"
ENV LAGOON=oc

COPY --from=golang /go/bin/envsubst /bin/envsubst

ARG LAGOON_VERSION
ENV LAGOON_VERSION=$LAGOON_VERSION

# Copy commons files
COPY --from=commons /lagoon /lagoon
COPY --from=commons /bin/fix-permissions /bin/ep /bin/docker-sleep /bin/
COPY --from=commons /sbin/tini /sbin/
COPY --from=commons /home /home

RUN chmod g+w /etc/passwd \
    && mkdir -p /home

ENV TMPDIR=/tmp \
    TMP=/tmp \
    HOME=/home \
    # When Bash is invoked via `sh` it behaves like the old Bourne Shell and sources a file that is given in `ENV`
    ENV=/home/.bashrc \
    # When Bash is invoked as non-interactive (like `bash -c command`) it sources a file that is given in `BASH_ENV`
    BASH_ENV=/home/.bashrc

# Defining Versions
ENV OC_VERSION=v3.7.2 \
    OC_HASH=282e43f \
    OC_SHA256=abc89f025524eb205e433622e59843b09d2304cc913534c4ed8af627da238624 \
    GLIBC_VERSION=2.28-r0

# To run the openshift client library `oc` we need glibc, install that first. Copied from https://github.com/jeanblanchard/docker-alpine-glibc/blob/master/Dockerfile
RUN apk add -U --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing aufs-util && \
    apk add --update openssl curl jq parallel && \
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    apk add glibc-bin.apk glibc.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*  && \
    apk add --no-cache bash git openssh py-pip && \
    git config --global user.email "lagoon@lagoon.io" && git config --global user.name lagoon && \
    pip install shyaml && \
    mkdir -p /openshift-origin-client-tools && \
    curl -Lo /tmp/openshift-origin-client-tools.tar https://github.com/openshift/origin/releases/download/${OC_VERSION}/openshift-origin-client-tools-${OC_VERSION}-${OC_HASH}-linux-64bit.tar.gz && \
    echo "$OC_SHA256  /tmp/openshift-origin-client-tools.tar" | sha256sum -c -  && \
    mkdir /tmp/openshift-origin-client-tools && \
    tar -xzf /tmp/openshift-origin-client-tools.tar -C /tmp/openshift-origin-client-tools --strip-components=1 && \
    install /tmp/openshift-origin-client-tools/oc /usr/bin/oc && rm -rf /tmp/openshift-origin-client-tools  && rm -rf /tmp/openshift-origin-client-tools.tar && \
    curl -Lo /usr/bin/svcat https://download.svcat.sh/cli/latest/linux/amd64/svcat && \
    chmod +x /usr/bin/svcat

ENTRYPOINT ["/sbin/tini", "--", "/lagoon/entrypoints.sh"]
