FROM registry.hub.docker.com/library/golang:1.17

WORKDIR /usr/local/kubebuilder
COPY /hack/tools /usr/local/kubebuilder/
RUN ./install_kustomize.sh && \
    ./install_kubebuilder.sh