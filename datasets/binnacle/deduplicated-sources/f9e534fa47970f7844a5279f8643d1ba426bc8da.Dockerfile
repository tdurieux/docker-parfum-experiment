FROM fedora:29

MAINTAINER Jarle Aase <jgaa@jgaa.com>

RUN echo "root:password" | chpasswd
RUN useradd jenkins
RUN echo "jenkins:jenkins" | chpasswd

RUN dnf -y update &&\
    dnf -y install @development-tools git jre-openjdk zlib-devel openssl-devel boost-devel cmake gcc-c++ openssh-server

# expose the ssh port
EXPOSE 22

# entrypoint by starting sshd
CMD ["/usr/sbin/sshd", "-D"]

