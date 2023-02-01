FROM ubuntu:16.04

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y software-properties-common uidmap \
    && add-apt-repository -y ppa:projectatomic/ppa \
    && apt-get update -qq \
    && apt-get -qq --no-install-recommends -y install podman \
    && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;

# Setup Rootless mode
#RUN adduser

#$ sudo usermod --add-subuids 10000-75535 podman
#$ sudo usermod --add-subgids 10000-75535 podman

# Change default storage driver to vfs
RUN sed -i "s/overlay/vfs/g" /etc/containers/storage.conf

# Add docker.io as a search registry
RUN sed -i '0,/\[\]/s/\[\]/["docker.io"]/' /etc/containers/registries.conf