FROM seafileltd/cluster-pro-base:18.04
WORKDIR /opt/seafile

ENV SEAFILE_VERSION=6.3.7 SEAFILE_SERVER=seafile-pro-server

RUN mkdir -p /etc/my_init.d

RUN mkdir -p /opt/seafile/

RUN curl -f -sSL -G -d "p=/pro/seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz&dl=1" https://download.seafile.com/d/6e5297246c/files/ \
    | tar xzf - -C /opt/seafile/

ADD scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh

COPY scripts /scripts
COPY templates /templates
RUN chmod u+x /scripts/*
