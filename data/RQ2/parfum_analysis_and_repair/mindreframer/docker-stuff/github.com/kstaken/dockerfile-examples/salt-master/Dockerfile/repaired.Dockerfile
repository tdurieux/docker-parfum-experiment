FROM ubuntu
MAINTAINER Kimbro Staken

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install --no-install-recommends -y wget sudo supervisor && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:saltstack/salt
RUN apt-get update

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN apt-get install --no-install-recommends -y salt-master openssh-server && rm -rf /var/lib/apt/lists/*;

RUN echo "root:salt-master" | chpasswd
RUN mkdir -p -m0755 /var/run/sshd

ADD ./supervisor-salt.conf /etc/supervisor/conf.d/

EXPOSE 4505 4506

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"] 
