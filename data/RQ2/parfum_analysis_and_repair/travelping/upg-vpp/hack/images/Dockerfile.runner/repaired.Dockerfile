FROM summerwind/actions-runner:latest

ENV BUILDKIT_VERSION "v0.8.2"
ENV BUILDCTL_SHA256 "b64aec46fb438ea844616b3205c33b01a3a49ea7de1f8539abd0daeb4f07b9f9"
ENV KUBECTL_VERSION "v1.20.0"
ENV KUBECTL_SHA256 "a5895007f331f08d2e082eb12458764949559f30bcc5beae26c38f3e2724262c"

RUN curl -f -sSL "https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz" | \
    sudo tar -xvz -C /usr/local bin/buildctl && \
    echo "${BUILDCTL_SHA256}  /usr/local/bin/buildctl" | sha256sum -c && \
    sudo curl -f -sSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    echo "${KUBECTL_SHA256}  /usr/local/bin/kubectl" | sha256sum -c && \
    sudo chmod +x /usr/local/bin/kubectl
