FROM debian:stretch-slim
MAINTAINER source{d}

RUN apt-get update && \
    apt-get install --no-install-recommends -y glusterfs-common && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

ADD build/bin/borges-tool /bin/

CMD ["bash"]
