FROM centos:latest

RUN yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2 && rm -rf /var/cache/yum
RUN yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y docker-ce && rm -rf /var/cache/yum

# Add services to test dns resolution
RUN yum -y install sudo NetworkManager dnsmasq && rm -rf /var/cache/yum

# To use run: `docker run --privileged -it --name dind -d docker:dind` to start a docker server
# Then add `--link dind:docker` to the run of this container to connect to it
ENV DOCKER_HOST tcp://docker:2375
