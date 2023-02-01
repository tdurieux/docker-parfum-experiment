# Description:
#   This runtime environment example Dockerfile creates a container with a minimal Ubuntu server and telnetd server
# Usage:
#   From this directory, run $ sudo docker build -t tsystemdkalienv .
# By default, runs as root
FROM kalilinux/kali:latest

ENV DEBIAN_FRONTEND noninteractive
# Setup ENV for systemd
ENV container docker

#update and upgrade
RUN apt-get update
RUN apt-get upgrade -y

#install utilities and dependencies
RUN apt-get install --no-install-recommends apt-utils dpkg-dev net-tools iputils-ping -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sudo build-essential vim help2man autotools-dev autoconf -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends inetutils-inetd inetutils-telnetd -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends systemd systemd-sysv -y && rm -rf /var/lib/apt/lists/*;

#set the root password
#RUN echo -e "root\ntoor" | passwd

#hack /etc/pam.d/login to disable pam_securetty
RUN sed -i 's/auth \[success\=ok new_authtok_reqd\=ok ignore\=ignore user_unknown\=bad default\=die\] pam_securetty.so/#auth \[success\=ok new_authtok_reqd\=ok ignore\=ignore user_unknown\=bad default\=die\] pam_securetty.so/g' /etc/pam.d/login

#RUN echo "telnet                  stream  tcp     nowait  root    /usr/local/libexec/telnetd      telnetd" >> /etc/inetd.conf
RUN echo "telnet                  stream  tcp     nowait  root    /usr/sbin/telnetd      telnetd" >> /etc/inetd.conf

VOLUME [ "/sys/fs/cgroup" ]

# Finished!
RUN echo 'Container is ready, run it using $ sudo docker run -d --name tsystemdkalienv --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --network host tsystemdkalienv:latest'
RUN echo 'Then attach to it using $ sudo docker exec -it tsystemdkalienv bash'

CMD ["/lib/systemd/systemd"]

#https://hub.docker.com/r/jrei/systemd-ubuntu/dockerfile
