FROM docker:dind

ENV HELM_VER 2.12.3

RUN apk add --no-cache bash \
            git \
            curl \
            bash-completion \
            jq \
            ca-certificates && \
    curl -f -L https://cdn.porter.sh/latest/install-linux.sh | bash && \
    curl -f -o helm.tgz https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VER}-linux-amd64.tar.gz && \
    tar -xzf helm.tgz && \
    mv linux-amd64/helm /usr/local/bin && \
    rm helm.tgz && \
    helm init --client-only && \
    mkdir -p /workshop

ENV PATH="$PATH:/root/.porter"

WORKDIR /workshop