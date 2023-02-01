FROM debian:stretch

MAINTAINER Jarle Aase <jgaa@jgaa.com>

RUN DEBIAN_FRONTEND="noninteractive" apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -y -q --no-install-recommends upgrade && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y -q \
    openssh-server g++ git \
    build-essential \
    zlib1g-dev g++ cmake make libboost-all-dev libssl-dev \
    openjdk-8-jdk && \
    apt-get -y -q autoremove && \
    apt-get -y -q clean && rm -rf /var/lib/apt/lists/*;

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]
