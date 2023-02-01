FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  wget \
  iproute2 \
  iputils-ping \
  tcpdump \
  telnet \
  traceroute \
  && rm -rf /var/lib/apt/lists/*

RUN curl -f -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
&& chmod +x kubectl \
&& mv kubectl /usr/local/bin/kubectl
