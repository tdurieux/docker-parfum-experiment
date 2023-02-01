FROM python:2.7-stretch

ENV VERSION=12.0.3

RUN set -x \
    && apt-get -y update \
    && apt-get install --no-install-recommends -y libffi-dev python-dev libssl-dev netcat default-libmysqlclient-dev \
    && apt-get -y clean all && rm -rf /var/lib/apt/lists/*;

RUN curl -fSL https://tarballs.openstack.org/keystone/keystone-${VERSION}.tar.gz -o keystone-${VERSION}.tar.gz \
    && tar xvf keystone-${VERSION}.tar.gz \
    && cd keystone-${VERSION} \
    && pip install --no-cache-dir -r requirements.txt \
    && PBR_VERSION=${VERSION} pip --no-cache-dir install . \
    && cp -r etc /etc/keystone \
    && cd - \
    && rm -rf keystone-${VERSION}* && rm keystone-${VERSION}.tar.gz

COPY ./helpers/docker/keystone/keystone.conf /etc/keystone/keystone.conf
COPY ./helpers/docker/keystone/bootstrap_fn.sh /etc/bootstrap_fn.sh
COPY ./helpers/docker/keystone/bootstrap.sh /etc/bootstrap.sh
COPY ./helpers/docker/keystone/create_db.py /etc/create_db.py
COPY ./helpers/docker/keystone/requirements.txt /etc/requirements.txt

RUN pip install --no-cache-dir -r /etc/requirements.txt \
    && pip install --no-cache-dir python-openstackclient==4.0.0

RUN chown root:root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

EXPOSE 5000 35357
