FROM debian:buster

RUN apt update && apt upgrade -y && \
    apt install --no-install-recommends -y git curl make gcc apt-transport-https ca-certificates gnupg-agent software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
$(lsb_release -cs) \
stable"

RUN apt-get update && \
    apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;

ENV GALLY=0.0.40
ENV KUSTOMIZE=3.8.8
ENV OPERATORSDK=1.3.0
ENV KUTTL=0.7.2
ENV OPM=1.15.3

RUN cd /usr/local/bin && \
  curl -f -Lo opm https://github.com/operator-framework/operator-registry/releases/download/v${OPM}/linux-amd64-opm && \
  curl -f -LO https://github.com/missena-corp/gally/releases/download/v${GALLY}/gally_${GALLY}_linux_x86_64.tar.gz && \
  curl -f -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE}/kustomize_v${KUSTOMIZE}_linux_amd64.tar.gz && \
  curl -f -Lo kubectl-kuttl https://github.com/kudobuilder/kuttl/releases/download/v${KUTTL}/kubectl-kuttl_${KUTTL}_linux_x86_64 && \
  tar -xvf gally_${GALLY}_linux_x86_64.tar.gz gally && \
  tar -xvf kustomize_v${KUSTOMIZE}_linux_amd64.tar.gz kustomize && \
  rm -f gally_${GALLY}_linux_x86_64.tar.gz kustomize_v${KUSTOMIZE}_linux_amd64.tar.gz && \
  chmod +x gally kustomize kubectl-kuttl opm

RUN cd /usr/local/bin && \
  curl -f -Lo operator-sdk https://github.com/operator-framework/operator-sdk/releases/download/v${OPERATORSDK}/operator-sdk_linux_amd64 && \
  chmod +x operator-sdk

ENV PATH="/usr/local/go/bin:${PATH}"

COPY --from=golang:1.15 /usr/local/go/ /usr/local/go/

