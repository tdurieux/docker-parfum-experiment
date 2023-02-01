# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node, capable of building mkfs.axfs and the kernel.  Derived from evarga/jenkins-slave
FROM ubuntu:trusty
MAINTAINER Jared Hulbert <jaredeh@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# Install stuff basic tools
RUN apt-get install -y rake
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y autoconf

# Install objective c
RUN apt-get install -y gobjc
RUN apt-get install -y gnustep
RUN apt-get install -y gnustep-make
RUN apt-get install -y libgnustep-base-dev

# Install kernel build helpers
RUN apt-get install -y libncurses-dev
RUN apt-get install -y wget
RUN apt-get install -y bc
RUN apt-get install -y ruby
RUN apt-get install -y ruby-dev
RUN gem install open4
RUN gem install ffi
RUN apt-get install -y xz-utils

# Mount point for local git repos
RUN mkdir -p /opt/git/
