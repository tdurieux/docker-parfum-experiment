FROM	    ubuntu:latest
MAINTAINER  Sam <sam@gigachad.com>

RUN	    apt update -y; apt upgrade -y
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libncurses-dev && rm -rf /var/lib/apt/lists/*;
ADD	    https://github.com/sambattalio/chad_stride/archive/0.6951.tar.gz /tmp
RUN tar xvf /tmp/*.tar.gz -C /tmp && rm /tmp/*.tar.gz
RUN	    cd /tmp/chad_stride-*; make install

ENTRYPOINT  ["/usr/local/bin/chad_stride"]
