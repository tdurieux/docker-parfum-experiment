# the AnchorWave docker
FROM ubuntu:latest

WORKDIR /

# from here: https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
# add the RUN DEBIAN_FRONTEND="noninteractive" before apt-get to prevent it from
# prompting for a geographic area
# BUT ... adding this export didn't help - I still had to define this explictly
# on the maven install.
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make git zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses-dev && rm -rf /var/lib/apt/lists/*;


# Install additional application we may need: vim, maven, etc  using apt-get

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install cmake && rm -rf /var/lib/apt/lists/*;

WORKDIR /


RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

#Install Minimap2
RUN git clone https://github.com/lh3/minimap2
WORKDIR minimap2
RUN make

# Export values needed for anchorwave
RUN export LD_LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/9
RUN export CC=/usr/bin/gcc
RUN export CXX=/usr/bin/g++
# download/compile anchorwave
WORKDIR /
RUN git clone https://github.com/baoxingsong/anchorwave.git && \
        cd anchorwave && \
	cmake ./ && \
	make


WORKDIR /anchorwave

ENV PATH=$PATH:/minimap2
ENV PATH=$PATH:/anchorwave
#Set the classpath to include / otherwise if the workdir of the container is not / the groovy scripts will not work correctly.
ENV CLASSPATH=$CLASSPATH:/

WORKDIR /
