FROM ubuntu:14.04
MAINTAINER Andrei Vacariu <andrei@avacariu.me>
EXPOSE 514

# MAINTAIN THE SAME ORDER OF USER CREATION BETWEEN ALL DOCKERFILES SO THAT THEY
# ALL END UP WITH THE SAME UID/GID
RUN groupadd -r lensing \
      && useradd -r -s /bin/false -g lensing lensing

RUN apt-get update && \
      apt-get -y --no-install-recommends install rsyslog && rm -rf /var/lib/apt/lists/*;

ADD ./rsyslog.conf /etc/rsyslog.conf

VOLUME ["/run/rsyslog"]

CMD ["rsyslogd", "-n"]
