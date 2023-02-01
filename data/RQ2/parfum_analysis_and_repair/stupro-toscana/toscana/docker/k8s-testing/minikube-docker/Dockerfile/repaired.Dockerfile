FROM solita/ubuntu-systemd
ADD install-minikube.sh /
ADD install-docker.sh /
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y wget sudo curl && \
    cd bin/ && \
    curl -f -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    cd .. && \
    sh install-docker.sh && \
    sh install-minikube.sh && rm -rf /var/lib/apt/lists/*;
RUN minikube start --vm-driver=none
