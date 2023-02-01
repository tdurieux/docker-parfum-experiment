FROM maestro_build
RUN apt-get update -qq --fix-missing && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl wget && \
    curl -f -L -o docker-1.9.1.tgz https://get.docker.com/builds/Linux/x86_64/docker-1.9.1.tgz && \
    tar xzvf docker-1.9.1.tgz -C / && \
    rm docker-1.9.1.tgz && \
    mkdir -p /opt/bin/ && \
    curl -f -L -o /opt/bin/kubectl \
    -z /opt/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/v1.2.4/bin/linux/amd64/kubectl && \
    chmod 755 /opt/bin/kubectl && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/bin/bash"]
