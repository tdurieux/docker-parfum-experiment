FROM busybox AS downloader
ARG LINKERD_VERSION
ENV LINKERD_VERSION=$LINKERD_VERSION
ARG LINKERD_CHECKSUM
ENV LINKERD_CHECKSUM=$LINKERD_CHECKSUM
ARG KUBECTL_VERSION
ENV KUBECTL_VERSION=$KUBECTL_VERSION
ARG KUBECTL_CHECKSUM
ENV KUBECTL_CHECKSUM=$KUBECTL_CHECKSUM

RUN wget https://github.com/linkerd/linkerd2/releases/download/${LINKERD_VERSION}/linkerd2-cli-${LINKERD_VERSION}-linux-amd64
RUN mv linkerd2-* /linkerd
RUN sh -c 'echo "${LINKERD_CHECKSUM}  /linkerd" | sha256sum -w -c'
RUN chmod +x /linkerd

RUN wget https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN mv kubectl /kubectl
RUN sh -c 'echo "${KUBECTL_CHECKSUM}  /kubectl" | sha256sum -w -c'
RUN chmod +x /kubectl

FROM busybox
COPY --from=downloader /linkerd /usr/local/bin/linkerd
COPY --from=downloader /kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/linkerd"]