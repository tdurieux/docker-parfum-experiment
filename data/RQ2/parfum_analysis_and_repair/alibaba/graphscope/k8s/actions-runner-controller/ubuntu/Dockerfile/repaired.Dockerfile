FROM summerwind/actions-runner-dind:latest

RUN sudo apt update -y \
  && sudo apt install --no-install-recommends -y \
  cmake \
  maven \
  openjdk-8-jdk \
  openssh-server \
  && sudo rm -rf /var/lib/apt/lists/*

RUN sudo curl -f -L -o /home/runner/hadoop-2.10.1.tar.gz https://mirror.cogentco.com/pub/apache/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz

RUN sudo curl -f -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/v1.23.5/bin/linux/amd64/kubectl" \
  && sudo chmod 0755 /usr/local/bin/kubectl

RUN curl -f https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN sudo curl -f -L -o /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && sudo chmod 0755 /usr/local/bin/minikube
