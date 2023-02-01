# Dockerfile for installing the necessary dependencies for running Hadoop and Spark

FROM ubuntu:latest

MAINTAINER Mingliang Liu <liuml07@apache.org>
MAINTAINER Weiqing Yang <wyang@hortonworks.com>

RUN apt-get update -y
RUN apt-get upgrade -y

# install openjdk
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# install and configure ssh service
RUN apt-get install --no-install-recommends -y openssh-server \
    && mkdir -p /var/run/sshd && rm -rf /var/lib/apt/lists/*;
# configure ssh free key access
RUN echo 'root:hortonworks' | chpasswd
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" \
    && cat /root/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && echo "HashKnownHosts no" >> ~/.ssh/config \
    && echo "StrictHostKeyChecking no" >> ~/.ssh/config

# set supervisor
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN echo "[program:sshd]" >> /etc/supervisor/supervisord.conf \
    && echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/supervisord.conf

# install general tools
RUN apt-get install --no-install-recommends -y iproute2 vim inetutils-ping && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

EXPOSE 22 9000 50020 50030

CMD /usr/bin/supervisord -n
