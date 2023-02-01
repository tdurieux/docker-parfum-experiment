FROM bash:latest
ENV LINKERD2_VERSION=stable-2.10.2
RUN apk --no-cache add dumb-init gettext ca-certificates openssl curl \
    && curl -f -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x /usr/local/bin/kubectl \
    && curl -f -sL https://run.linkerd.io/install | sh \
    && ln -s /root/.linkerd2/bin/linkerd /usr/local/bin/linkerd

WORKDIR /
COPY install-linkerd.sh /
RUN chmod +x install-linkerd.sh

ENTRYPOINT /usr/local/bin/bash /install-linkerd.sh
