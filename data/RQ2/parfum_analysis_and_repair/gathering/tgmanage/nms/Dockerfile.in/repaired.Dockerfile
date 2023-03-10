@template nms-base

FROM debian:jessie

ENV container docker
MAINTAINER "Kristian" <kly@kly.no>
#RUN systemctl set-default basic.target
RUN apt-get update && apt-get -y --no-install-recommends install \
     wget \
     vim \
     man \
     build-essential \
     net-tools \
     bash-completion \
     git-core \
     autoconf \
     netcat \
     libwww-perl \
     libmicrohttpd-dev \
     libcurl4-gnutls-dev \
     libedit-dev \
     libpcre3-dev \
     libncurses5-dev \
     python-demjson \
     python-docutils \
     libtool \
     nodejs \
     httpie \
     locales \
     screen \
     openssh-server \
     pkg-config && rm -rf /var/lib/apt/lists/*;

VOLUME [ "/sys/fs/cgroup" ]
VOLUME [ "/run" ]
VOLUME [ "/run/lock" ]
RUN echo en_US.UTF8 UTF-8 > /etc/locale.gen
RUN locale-gen
RUN echo 'LANG="en_US.utf8"' > /etc/default/locale
RUN echo . /etc/default/locale >> /root/.bashrc
RUN echo export LANG >> /root/.bashrc
RUN echo . /etc/bash_completion >> /root/.bashrc
ENV TERM=rxvt-unicode
RUN rm /etc/apt/apt.conf.d/docker-clean
RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service
RUN git clone https://github.com/tech-server/tgmanage.git /srv/tgmanage
#RUN systemctl disable systemd-logind.service
CMD ["/sbin/init"]

@template nms-front
FROM nms-base
RUN apt-get -y --no-install-recommends install \
    libcapture-tiny-perl \
    libcgi-pm-perl \
    libcommon-sense-perl \
    libdata-dumper-simple-perl \
    libdbd-pg-perl \
    libdbi-perl \
    libdigest-perl \
    libgd-perl \
    libgeo-ip-perl \
    libhtml-parser-perl \
    libhtml-template-perl \
    libimage-magick-perl \
    libimage-magick-q16-perl \
    libjson-perl \
    libjson-xs-perl \
    libnetaddr-ip-perl \
    libnet-cidr-perl \
    libnet-ip-perl \
    libnet-openssh-perl \
    libnet-oping-perl \
    libnet-rawip-perl \
    libnet-telnet-cisco-perl \
    libnet-telnet-perl \
    libsnmp-perl \
    libsocket6-perl \
    libsocket-perl \
    libswitch-perl \
    libtimedate-perl \
    perl \
    perl-base \
    perl-modules \
    varnish \
    libfreezethaw-perl \
    apache2 && rm -rf /var/lib/apt/lists/*;

RUN cd /srv/tgmanage/ && tools/get_mibs.sh

# Apache shait
RUN a2dissite 000-default
RUN a2enmod cgi
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
RUN ln -s /srv/tgmanage/web/etc/apache2/nms.tg16.gathering.org.conf /etc/apache2/sites-enabled/
#(no, not for production, it's just demo:demo during development)
RUN echo 'demo:$apr1$IKrQYF6x$0zmRciLR7Clc2tEEosyHV.' > /srv/tgmanage/web/htpasswd-read
RUN echo 'demo:$apr1$IKrQYF6x$0zmRciLR7Clc2tEEosyHV.' > /srv/tgmanage/web/htpasswd-write
RUN systemctl enable apache2

# Varnish shait
RUN rm /etc/varnish/default.vcl
RUN ln -s /srv/tgmanage/web/etc/varnish/nms.vcl /etc/varnish/default.vcl
RUN sed -i 's/6081/80/' /lib/systemd/system/varnish.service
RUN systemctl enable varnish

ADD config.pm /srv/tgmanage/include/

@template nms-db
FROM nms-base
RUN apt-get install --no-install-recommends -y postgresql-doc-9.4 postgresql-9.4 && rm -rf /var/lib/apt/lists/*;
ADD nms-dump.sql /
ADD postgresql.conf /etc/postgresql/9.4/main/
ADD pg_hba.conf /etc/postgresql/9.4/main/
RUN chown -R postgres:postgres /etc/postgresql/
RUN chmod a+r /etc/postgresql/9.4/main/*conf
RUN service postgresql start && su postgres -c "psql --command=\"CREATE ROLE nms PASSWORD 'md5f6f0a94af5ec8b6001e41b8f06fd22d8' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\"" && su postgres -c "createdb -O nms nms" && service postgresql stop
RUN service postgresql start && su postgres -c "cat /nms-dump.sql | psql nms" && service postgresql stop
RUN service postgresql start && su postgres -c "psql --command=\"ALTER ROLE nms PASSWORD 'md5f6f0a94af5ec8b6001e41b8f06fd22d8';\"" && service postgresql stop
EXPOSE 5432
