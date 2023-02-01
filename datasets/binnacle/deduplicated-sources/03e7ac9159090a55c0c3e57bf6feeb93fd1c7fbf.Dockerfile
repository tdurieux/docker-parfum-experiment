FROM debian:stretch-slim

LABEL maintainer="packaging@redmintnetwork.fr"
EXPOSE 8077

COPY --chown=_apt:root repo /repo
COPY loudml-1.x.list /etc/apt/sources.list.d/loudml-1.x.list

RUN apt-get update \
    && apt-get install -y python3-pip \
    && apt-get install -y --allow-unauthenticated \
               loudml loudml-base \
    && apt-get purge -y

COPY loudml.yml /etc/loudml/config.yml
CMD /usr/bin/loudmld
