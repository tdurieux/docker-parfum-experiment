FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/containerd/containerd/releases/download/v1.4.3/containerd-1.4.3-linux-amd64.tar.gz
RUN tar xvf containerd-1.4.3-linux-amd64.tar.gz && rm containerd-1.4.3-linux-amd64.tar.gz