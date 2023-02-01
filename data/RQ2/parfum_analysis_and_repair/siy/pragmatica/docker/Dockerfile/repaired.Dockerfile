FROM ubuntu:21.04
ENV LANG C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -qy && \
    apt-get install --no-install-recommends -qy \
        build-essential \
        git \
        openjdk-17-jdk \
        make \
        mc \
        zip \
        unzip \
        xz-utils \
        bzip2 && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

CMD ["/bin/bash"]
