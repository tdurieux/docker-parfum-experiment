FROM stackbrew/ubuntu:12.04
MAINTAINER Matt Bentley <mbentley@mbentley.net>
RUN (echo "deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse" > /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y openssh-server && rm -rf /var/lib/apt/lists/*;

ADD authorized_keys /authorized_keys
ADD configure.sh /configure.sh
RUN bin/bash /configure.sh && rm /configure.sh

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
