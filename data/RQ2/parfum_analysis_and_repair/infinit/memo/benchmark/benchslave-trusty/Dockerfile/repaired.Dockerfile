FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install --no-install-recommends -y fuse && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nfs-kernel-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ssh && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-add-repository multiverse
RUN apt-get update

RUN apt-get install --no-install-recommends -y bonnie++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dbench && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iozone3 && rm -rf /var/lib/apt/lists/*;

ADD .ssh /root/.ssh
RUN chmod -R go-rw /root/.ssh
ADD scripts /scripts
ADD server_home /server_home
ADD client_home /client_home

# NFS
EXPOSE 111/udp 111/tcp 2049/tcp 2049/udp
# Infinit
EXPOSE 60000/udp 60000/tcp
