FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    export DEBCONF_NONINTERACTIVE_SEEN=true; \
    apt-get update && apt-get -y --no-install-recommends install \
    cmake \
    debhelper \
    devscripts \
    g++ \
    git \
    libboost-program-options-dev \
    libmapnik-dev \
    libprotobuf-dev \
    libshp-dev \
    protobuf-compiler \
    qtbase5-dev \
    openssh-server \
    openjdk-8-jre-headless \
    && dpkg-reconfigure openssh-server && mkdir -p /var/run/sshd && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;

# Setup a user account for everything else to be done under
RUN useradd -d /home/user/ -u 1000 --user-group --create-home -G video user

# Create the staging directory and ensure our user account owns it
RUN mkdir /output && chown user:user /output

COPY build-tilegenerator.sh build-tirex.sh test-tilegenerator.sh /usr/bin/

# Make SSH in services available
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
