FROM ubuntu:18.04

ARG cpython_install
ARG python_soabi
ARG platform_triplet
ARG python_version

ENV DEBIAN_FRONTEND noninteractive
#ENV http_proxy http://proxy-address:proxy-port
#ENV https_proxy https://proxy-address:proxy-port

RUN mkdir /scripts && mkdir /cpython
ADD $cpython_install /cpython

COPY files/ /django-workload/

RUN apt-get update && apt-get install --no-install-recommends -y git python3-virtualenv python3-dev \
        python-pip libmemcached-dev zlib1g-dev netcat-openbsd && rm -rf /var/lib/apt/lists/*;
RUN cd /django-workload/django-workload                       \
    && python3 -m virtualenv -p /cpython/bin/python3  venv    \
    && ln -s config-"$python_version""$python_soabi"-"$platform_triplet" venv/lib/python"$python_version"/config-"$python_version""$python_soabi" \
    && ln -s libpython"$python_version""$python_soabi".a venv/lib/python"$python_version"/config-"$python_version""$python_soabi"/libpython"$python_version".a \
    && . venv/bin/activate \
    && pip install --no-cache-dir -r requirements.txt \
    && deactivate \
    && cp cluster_settings_template.py cluster_settings.py

COPY files/set_sysctl.conf files/uwsgi_init.sh /scripts/
RUN echo "Add nf_conntrack to modules ...\n"\
    && echo "nf_conntrack" >> /etc/modules \
    && echo "Add limits settings ...\n"\
    && echo "root soft nofile 1000000" >> /etc/security/limits.conf \
    && echo "root hard nofile 1000000" >> /etc/security/limits.conf

RUN cp /scripts/set_sysctl.conf /etc/sysctl.conf

ENV DEBIAN_FRONTEND teletype

CMD /scripts/uwsgi_init.sh uwsgi
