# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.

FROM ubuntu:14.04

RUN apt-get update

# Install a basic SSH server
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y --no-install-recommends openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]