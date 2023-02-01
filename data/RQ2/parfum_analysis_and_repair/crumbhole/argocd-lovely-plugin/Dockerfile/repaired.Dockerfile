FROM golang:1.18.1 as builder

RUN apt update && apt install --no-install-recommends -y curl wget unzip && rm -rf /var/lib/apt/lists/*;

# Install Helm
RUN curl -f -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Kustomize
RUN curl -f -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && mv /go/kustomize /usr/local/bin

# Install yq
RUN curl -f -L -s "https://github.com/mikefarah/yq/releases/download/v4.20.1/yq_linux_amd64" -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq

ADD . /build
WORKDIR /build
RUN make -j4

FROM alpine as putter
COPY --from=builder /build/build/argocd-lovely-plugin .
ENTRYPOINT [ "mv", "argocd-lovely-plugin", "/custom-tools/" ]
