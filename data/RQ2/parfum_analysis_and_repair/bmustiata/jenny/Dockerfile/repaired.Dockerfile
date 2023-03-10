FROM ubuntu:16.04

RUN apt update -y && \
    apt upgrade -y && \
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update -y && \
    apt install --no-install-recommends -y groovy curl maven python3.6 && \
    curl -f https://get.docker.com | bash && rm -rf /var/lib/apt/lists/*;

RUN useradd -m germanium && \
    usermod -G docker germanium && \
    echo 'DOCKER_OPTS="-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"' >> /etc/default/docker

USER germanium
RUN mkdir /home/germanium/.jenny && \
    echo "noLogo: false" > /home/germanium/.jenny/config
