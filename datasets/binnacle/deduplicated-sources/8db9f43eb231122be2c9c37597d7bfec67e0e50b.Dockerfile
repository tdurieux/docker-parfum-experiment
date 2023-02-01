# -*- coding: utf-8 -*-
#
# This file is part of hepcrawl.
# Copyright (C) 2017 CERN.
#
# hepcrawl is a free software; you can redistribute it and/or modify it
# under the terms of the Revised BSD License; see LICENSE file for
# more details.

FROM centos

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y \
        file \
        gcc \
        git \
        libffi-devel \
        libxml2-devel \
        libxslt-devel \
        libssl-devel \
        make \
        openssl-devel \
        poppler-utils \
        python-pip \
        python-virtualenv && \
    yum clean all

RUN mkdir /code /hepcrawl_venv /var/lib/scrapy

RUN useradd test
RUN chown -R test:test /code /hepcrawl_venv /var/lib/scrapy

ADD ./docker_entrypoint.sh /docker_entrypoint.sh
ADD ./fix_rights /fix_rights
RUN chmod 4755 /fix_rights

USER test
WORKDIR /code

ENTRYPOINT ["/docker_entrypoint.sh"]
CMD true
