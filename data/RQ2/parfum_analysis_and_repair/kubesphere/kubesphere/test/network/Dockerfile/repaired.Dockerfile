FROM golang:1.12

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https jq openssl libltdl7 && \
    go get -u github.com/onsi/ginkgo/ginkgo && \
    curl -f -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | \
    grep browser_download | \
    grep linux | \
    cut -d '"' -f 4 | \
    xargs curl -O -L && \
    mv kustomize_*_linux_amd64 kustomize && \
    chmod u+x kustomize && \
    mv kustomize /usr/bin/ && rm -rf /var/lib/apt/lists/*;

