FROM {{ "ci-buster" | image_tag }}
{% set packages|replace('\n', ' ') -%}
python-pip
python-dev
python-wheel
python3-pip
python3-dev
python3.5-dev
python3.6-dev
python3.7-dev
python3.8-dev
python3-lxml
python3-wheel
pypy
gcc
g++
libc-dev
make
default-libmysqlclient-dev
libssl-dev
libcurl4-openssl-dev
gettext
shellcheck
libffi-dev
libpq-dev
librdkafka-dev
python-etcd
python-conftool
etcd
libldap2-dev
libsasl2-dev
libexiv2-dev
libboost-python-dev
{%- endset -%}

ARG PIP_DISABLE_PIP_VERSION_CHECK=1

ADD pyall.list /etc/apt/sources.list.d/pyall.list
ADD cobertura-clover-transform.py /usr/bin/cobertura-clover-transform
ADD cobertura-clover-transform.xslt /usr/bin/cobertura-clover-transform.xslt
ADD apt.pref /etc/apt/preferences.d/pinning.pref

RUN {{ packages | apt_install }} \
    && pip3 install --no-cache-dir setuptools \
    && pip3 install --no-cache-dir tox==3.21.4 \
    && rm -fR "$XDG_CACHE_HOME/pip"

USER nobody
# workaround https://github.com/pypa/virtualenv/issues/1640
ENV XDG_DATA_HOME=/tmp
WORKDIR /src
ENTRYPOINT ["/run.sh"]
COPY run.sh /run.sh
