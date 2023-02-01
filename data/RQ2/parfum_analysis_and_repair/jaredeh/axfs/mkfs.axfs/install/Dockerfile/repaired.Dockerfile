# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node, capable of building mkfs.axfs and the kernel.  Derived from evarga/jenkins-slave
FROM ubuntu:trusty
MAINTAINER Jared Hulbert <jaredeh@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install --no-install-recommends -y openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# Install stuff basic tools
RUN apt-get install --no-install-recommends -y rake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;

# Install objective c
RUN apt-get install --no-install-recommends -y gobjc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnustep && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnustep-make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgnustep-base-dev && rm -rf /var/lib/apt/lists/*;

# Install kernel build helpers
RUN apt-get install --no-install-recommends -y libncurses-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install open4
RUN gem install ffi
RUN apt-get install --no-install-recommends -y xz-utils && rm -rf /var/lib/apt/lists/*;

# Mount point for local git repos
RUN mkdir -p /opt/git/
