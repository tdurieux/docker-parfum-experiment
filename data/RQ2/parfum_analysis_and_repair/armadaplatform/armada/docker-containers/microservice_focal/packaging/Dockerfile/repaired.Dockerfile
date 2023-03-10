FROM docker.io/ubuntu:20.04

# Set up container's timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        g++ \
        gcc \
        git \
        libc6-dev \
        libffi-dev \
        make \
        python3 \
        rpm \
        ruby \
        ruby-dev \
        rubygems && rm -rf /var/lib/apt/lists/*;

# Install package builder
RUN gem install fpm

COPY package_build.py /usr/bin/package_build
RUN chmod +x /usr/bin/package_build

WORKDIR "/opt/microservice"
VOLUME "/opt/microservice"
ENTRYPOINT ["/usr/bin/package_build"]
