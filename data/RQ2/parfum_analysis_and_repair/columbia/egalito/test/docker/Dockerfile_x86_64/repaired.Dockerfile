FROM debian:testing

MAINTAINER Miguel Arroyo miguel@cs.columbia.edu version: 0.1

RUN apt-get update && apt-get install --no-install-recommends -y \
build-essential \
lsb-release \
gdb \
git \
gosu \
libc6-dbg \
libcapstone-dev \
libreadline-dev \
libboost-python-dev \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]
