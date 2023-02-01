# Description:
#   This runtime environment example Dockerfile creates a container with a minimal Ubuntu server and nginx server
# Usage:
#   From this directory, run $ sudo docker build -t twebsvr .
# By default, runs as root
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
# Setup ENV for systemd
ENV container docker

#update and upgrade
RUN apt-get update
RUN apt-get upgrade -y

#install utilities and dependencies
RUN apt-get install --no-install-recommends apt-utils dpkg-dev net-tools iputils-ping -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends systemd systemd-sysv -y && rm -rf /var/lib/apt/lists/*;

#install all the things (web server)
RUN apt-get install --no-install-recommends nginx -y && rm -rf /var/lib/apt/lists/*;

#create the example site
RUN mkdir -p /var/www/nwsec
COPY index.html /var/www/nwsec/.
COPY etc_nginx_sites-available-nwsec /etc/nginx/sites-available/.
RUN ln -s /etc/nginx/sites-available/nwsec /etc/nginx/sites-enabled/nwsec

VOLUME [ "/sys/fs/cgroup" ]

# Finished!
RUN echo 'Container is ready, run it using $ sudo docker run -d --name websvr --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --network host twebsvr:latest'
RUN echo 'Then attach to it using $ sudo docker exec -it websvr bash'

CMD ["/lib/systemd/systemd"]
