#Drupal

FROM ubuntu

RUN	echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
RUN	echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list
RUN apt-get update

#Prevent daemon start during install
RUN	echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

#Supervisord
RUN apt-get install --no-install-recommends -y supervisor && mkdir -p /var/log/supervisor && rm -rf /var/lib/apt/lists/*;
CMD ["/usr/bin/supervisord", "-n"]

#SSHD
RUN apt-get install --no-install-recommends -y openssh-server && mkdir /var/run/sshd && echo 'root:root' |chpasswd && rm -rf /var/lib/apt/lists/*;

#Utilities
RUN apt-get install --no-install-recommends -y vim less ntp net-tools inetutils-ping curl git && rm -rf /var/lib/apt/lists/*;

#Varnish
RUN apt-get install --no-install-recommends -y varnish && rm -rf /var/lib/apt/lists/*;

#Config

#Supervisor starts everything
ADD	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 6081
