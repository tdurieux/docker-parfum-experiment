FROM ubuntu:16.04
MAINTAINER Harish Anand "https://github.com/harishanand95"

RUN apt-get update
RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install --no-install-recommends -y openssh-server sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python nano vim && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
ARG CACHEBUST=1
RUN sed -i '$ a LANG="en_US.UTF-8"' /etc/profile
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
COPY config/certificate_authority/keys/id_rsa.pub /root/.ssh/authorized_keys
EXPOSE 22
RUN sed -i '$ a LANG="en_US.UTF-8"' /etc/profile
CMD    ["/usr/sbin/sshd", "-D"]