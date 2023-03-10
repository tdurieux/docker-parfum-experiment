FROM ubuntu:22.04
LABEL maintainer="Charlie Lewis <clewis@iqt.org>"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -yq \
     build-essential \
     ca-certificates \
     cmake \
     git \
     g++ \
     iproute2 \
     libsctp-dev \
     lksctp-tools \
     tcpdump \
     iputils-ping \
     make \
     wget && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/aligungr/UERANSIM
WORKDIR /UERANSIM
RUN git checkout v3.2.6
RUN make
COPY scripts /scripts
ENTRYPOINT ["/bin/sh"]
