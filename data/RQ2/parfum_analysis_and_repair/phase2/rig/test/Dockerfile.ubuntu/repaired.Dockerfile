FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y --no-install-recommends install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
RUN apt-get update
RUN apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

# Add services to test dns resolution
RUN apt-get -y --no-install-recommends install sudo network-manager dnsmasq && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o /tmp/libnss-resolver.deb -L https://github.com/azukiapp/libnss-resolver/releases/download/v0.3.0/ubuntu16-libnss-resolver_0.3.0_amd64.deb \
    && dpkg -i /tmp/libnss-resolver.deb

# To use run: `docker run --privileged -it --name dind -d docker:dind` to start a docker server
# Then add `--link dind:docker` to the run of this container to connect to it
ENV DOCKER_HOST tcp://docker:2375

