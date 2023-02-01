FROM fedora:32
ENV container docker
ARG K8SVERSION
RUN dnf -y install moby-engine procps-ng iproute findutils \
    && curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v$K8SVERSION/bin/linux/amd64/kubectl \
    && chmod +x kubectl && mv kubectl /usr/local/bin
COPY mokctl.deploy /usr/bin/mokctl
CMD ["bash"]

# vim:ft=dockerfile
