FROM ubuntu:bionic

MAINTAINER Phocean <jc@phocean.net>

# PosgreSQL configuration
COPY ./scripts/db.sql /tmp/
COPY ./conf/database.yml /usr/share/metasploit-framework/config/

# Startup script
COPY ./scripts/init.sh /usr/local/bin/init.sh

# Installation
RUN apt-get update \
  && apt-get install -y \
    curl postgresql postgresql-contrib postgresql-client \
    apt-transport-https gnupg2\
    nmap nasm\
  && /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql" \
  && curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - \
  && echo "deb https://apt.metasploit.com/ jessie main" >> /etc/apt/sources.list \
  && apt-get update -qq \
  && apt-get install -y metasploit-framework \
  && apt-get remove -y apt-transport-https postgresql-contrib postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Configuration and sharing folders
VOLUME /root/.msf4/
VOLUME /tmp/data/

# Locales for tmux
ENV LANG C.UTF-8

CMD "init.sh"
