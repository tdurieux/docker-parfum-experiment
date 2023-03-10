FROM golang:1.18.0-alpine3.15

RUN apk -U add --no-cache \
  bash \
  ca-certificates \
  curl \
  g++ \
  gcc \
  git \
  jq \
  make \
  openssl \
  && update-ca-certificates

ARG GH_VERSION=2.5.2
RUN curl -f -L https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz --output gh.tar.gz \
  && tar -xzf gh.tar.gz \
  && mv gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin \
  && rm gh.tar.gz \
  && rm -rf gh_${GH_VERSION}_linux_amd64

RUN curl -f -Ls https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.3/kustomize_v4.5.3_linux_amd64.tar.gz --output kustomize.tar.gz \
  && tar -xzf kustomize.tar.gz \
  && mv ./kustomize /usr/bin \
  && rm kustomize.tar.gz

ENTRYPOINT [ "/bin/bash" ]
