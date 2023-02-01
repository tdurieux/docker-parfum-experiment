FROM registry.access.redhat.com/ubi8/python-36

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

## NOTE - rhel enforces user container permissions stronger ##
USER root
RUN yum install -y python3-pip wget && rm -rf /var/cache/yum

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir --upgrade pipenv \
  && pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

ENV FLASK_APP=server/__init__.py
ENV FLASK_DEBUG=true

COPY --chown=1000:1000 . /app
COPY --chown=1000:1000 run-dev /bin
RUN chmod 777 /bin/run-dev

USER 1000

ARG bx_dev_user=root
ARG bx_dev_userid=1000

RUN BX_DEV_USER=$bx_dev_user
RUN BX_DEV_USERID=$bx_dev_userid
RUN if [ "$bx_dev_user" != root ]; then adduser -D -s /bin/bash -u $bx_dev_userid $bx_dev_user; fi
