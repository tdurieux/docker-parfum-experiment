ARG tag=latest
FROM ubuntu:${tag}

RUN apt-get update && \
    apt-get -y --no-install-recommends install software-properties-common && \
    add-apt-repository ppa:acetcom/open5gs && \
    apt-get update && \
    apt-get install --no-install-recommends -y open5gs && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
