FROM ubuntu:14.04
RUN \
    sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y libffi-dev libssl-dev && \
    apt-get install --no-install-recommends -y clang-3.5 llvm && \
    sudo ln -s /usr/bin/clang-3.5 /usr/bin/clang && \
    sudo ln -s /usr/bin/clang++-3.5 /usr/bin/clang++ && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y curl wget && \
    apt-get install --no-install-recommends -y byobu git htop man unzip vim && \
    apt-get install --no-install-recommends -y python-pip python2.7-dev && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --upgrade virtualenv && \
    pip install --no-cache-dir pyopenssl ndg-httpsclient pyasn1 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /wikid
CMD make
