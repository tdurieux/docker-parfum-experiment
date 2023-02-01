# Description:
#   This runtime environment example Dockerfile creates a container with a minimal Kali server and suricata
# Usage:
#   From this directory, run $ docker build -t tsuricata .
#   By default, runs as root
#   https://suricata-ids.org

FROM kalilinux/kali-last-release:latest

#https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#avoid question/dialog during apt-get installs
ARG DEBIAN_FRONTEND noninteractive

#update
RUN apt-get update

#install utilities
RUN apt-get install apt-utils dpkg-dev debconf debconf-utils -y
RUN apt-get install net-tools iputils-ping iptables iproute2 wget nmap bind9-dnsutils dnsutils inetutils-traceroute isc-dhcp-common -y
RUN apt-get install vim acl sudo telnet ssh netcat-traditional nfs-common -y

#install dependencies for systemd and syslog
RUN apt-get install systemd systemd-sysv syslog-ng syslog-ng-core syslog-ng-mod-sql syslog-ng-mod-mongodb -y

VOLUME [ "/tmp", "/run", "/run/lock" ]
# Remove unnecessary units
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
  /etc/systemd/system/*.wants/* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /lib/systemd/system/systemd-update-utmp*
CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target" ]

RUN echo 'Install dependencies'
RUN apt-get install -y libpcre3 libpcre3-dbg libpcre3-dev 
RUN apt-get install -y build-essential autoconf automake libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev 
RUN apt-get install -y zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config

#install all the things (suricata)
RUN apt-get install -y software-properties-common
RUN apt-get install -y suricata jq

#configure suricata and install some rules
RUN mv /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.orig
RUN mv /etc/default/suricata /etc/default/suricata.orig
COPY etc_suricata_suricata.yaml /etc/suricata/suricata.yaml
COPY etc_default_suricata /etc/default/suricata
COPY var_lib_suricata_rules_test-ping.rules /var/lib/suricata/rules/test-ping.rules
COPY var_lib_suricata_rules_test-ping.rules /var/lib/suricata/rules/test-dos.rules
COPY var_lib_suricata_rules_test-ping.rules /var/lib/suricata/rules/test-mail.rules
RUN suricata-update

RUN echo $'\n\
* Container is ready, run it using $ docker run -d --name suricata --hostname jhedid-suricata.netsec.isi.jhu.edu --add-host jhedid-suricata.netsec.isi.jhu.edu:127.0.1.1 --dns 172.16.0.10 --dns-search netsec.isi.jhu.edu --privileged --security-opt seccomp=unconfined --cgroup-parent=docker.slice --cgroupns private --tmpfs /tmp --tmpfs /run --tmpfs /run/lock --network host --cpus=1 tsuricata:latest \n\
* Attach to it using $ docker exec -it suricata bash \n\
* suricata status is available using # systemctl status suricata \n\
* suricata can be stopped and started as well using systemctl'

#https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva/1083451#1083451
