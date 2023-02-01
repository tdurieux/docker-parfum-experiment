FROM docker.io/ubuntu:20.04

# Set up container's timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        git \
        libarchive-tools \
        libc6-dev \
        libffi-dev \
        make \
        python3 \
        rpm \
        ruby-dev \
        tar \
        xz-utils && rm -rf /var/lib/apt/lists/*;

# install package builder
RUN gem install fpm

COPY build_armada.py /usr/bin/build_armada
RUN chmod +x /usr/bin/build_armada

WORKDIR "/opt/armada"
VOLUME "/opt/armada"
ENTRYPOINT ["/usr/bin/build_armada"]
