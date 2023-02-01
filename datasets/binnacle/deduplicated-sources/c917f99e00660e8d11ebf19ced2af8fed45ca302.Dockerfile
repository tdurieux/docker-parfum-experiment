FROM debian:stretch

MAINTAINER Jarle Aase <jgaa@jgaa.com>

# In case you need proxy
RUN apt-get -q update &&\
    apt-get -y -q --no-install-recommends upgrade &&\
    apt-get -y -q install openssh-server g++ git \
    automake autoconf ruby ruby-dev rubygems build-essential \
    zlib1g-dev g++ cmake make libboost-all-dev libssl-dev \
    openjdk-8-jdk &&\
    gem install --no-ri --no-rdoc fpm &&\
    apt-get -y -q autoremove &&\
    apt-get -y -q clean

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]
