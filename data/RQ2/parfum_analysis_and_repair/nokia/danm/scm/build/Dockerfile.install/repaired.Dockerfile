FROM alpine:latest
ARG USERNAME=danm
ARG UID=147
ARG GID=147

ARG KUBECTL_VERSION=1.17.4
ARG CONFD_VERSION=0.16.0

RUN adduser -u ${UID} -D -H -s /bin/sh ${USERNAME} \
 && apk add --no-cache jq openssl wget \
 && if [ `uname -m` == "aarch64" ] ; then KUBECTL_ARCH="arm64"; else KUBECTL_ARCH="amd64"; fi \
 && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl \
 && mv kubectl /usr/local/bin/kubectl \
 && chmod 755 /usr/local/bin/kubectl \
 && wget -q https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-${KUBECTL_ARCH} \
 && mv confd-${CONFD_VERSION}-linux-${KUBECTL_ARCH} /usr/local/bin/confd \
 && chmod 755 /usr/local/bin/confd

COPY integration /integration
COPY scm/build/install/install.sh /
COPY scm/build/install/confd /etc/confd/

RUN mkdir /config-out \
 && chown ${UID}:${GID} /config-out \
 && chown -R ${UID}:${GID} /integration \
 && chown -R ${UID}:${GID} /etc/confd/templates

WORKDIR /
USER ${USERNAME}
ENTRYPOINT ["/install.sh"]