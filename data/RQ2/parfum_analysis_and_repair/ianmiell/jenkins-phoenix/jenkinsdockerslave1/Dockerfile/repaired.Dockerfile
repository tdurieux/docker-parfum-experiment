# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM ubuntu:trusty

# Make sure the package repository is up to date.
RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y openssh-server docker.io && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install --no-install-recommends -y openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN sed -i 's/^.sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers
RUN adduser jenkins sudo

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
