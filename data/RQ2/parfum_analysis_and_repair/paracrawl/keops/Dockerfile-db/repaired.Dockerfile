FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

COPY configure-db.sh /opt/
COPY docker-entrypoint-db.sh /opt/
COPY keopsdb_init.sql /opt/
COPY set-password.sh /opt/

RUN echo "Europe/Madrid" > /etc/timezone

RUN apt-get update -q --fix-missing && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install tzdata \
	postgresql-10 \
            dnsutils \
	sudo \
            python3 \
            python3-pip && \
    apt-get autoremove -y && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/*;

RUN /opt/configure-db.sh

RUN rm -r /opt/.git || :

CMD ./opt/docker-entrypoint-db.sh $POSTGRESPASSWORD $KEOPS_ROOT_PASSWORD
