# Use base UBI image
FROM registry.access.redhat.com/ubi8/ubi

WORKDIR /app

COPY Pipfile* /app/

# Install python3
RUN yum -y install --disableplugin=subscription-manager python36 \
  && yum --disableplugin=subscription-manager clean all && rm -rf /var/cache/yum

RUN yum -y install --disableplugin=subscription-manager python3-pip wget \
  && yum --disableplugin=subscription-manager clean all && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir pipenv
RUN pipenv install

# Update python command to point to python3 install
RUN alternatives --set python /usr/bin/python3

ENV FLASK_APP=server/__init__.py
ENV FLASK_DEBUG=true

COPY . /app
COPY run-dev /bin
RUN chmod 777 /bin/run-dev

ARG bx_dev_user=root
ARG bx_dev_userid=1000

RUN BX_DEV_USER=$bx_dev_user
RUN BX_DEV_USERID=$bx_dev_userid
RUN if [ "$bx_dev_user" != root ]; then useradd -ms /bin/bash -u $bx_dev_userid $bx_dev_user; fi
