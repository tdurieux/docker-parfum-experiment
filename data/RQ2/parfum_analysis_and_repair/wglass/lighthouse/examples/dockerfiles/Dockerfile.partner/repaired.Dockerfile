FROM ubuntu:14.04
MAINTAINER william.glass@gmail.com

RUN apt-get update \
    && apt-get install --no-install-recommends -y git \
       haproxy \
       python-pip python-virtualenv python-dev python-setuptools && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir supervisor
COPY supervisord/supervisord.conf /etc/supervisord/supervisord.conf
RUN mkdir -p /var/log/supervisor/

RUN virtualenv -p /usr/bin/python2.7 /opt/venvs/tokenapi
RUN . /opt/venvs/tokenapi/bin/activate; pip install --no-cache-dir flask
COPY apps/tokenapi.py /opt/venvs/tokenapi/bin/

COPY supervisord/tokenapi.conf /etc/supervisord/conf.d/

# partner api port
EXPOSE 88

CMD supervisord -c /etc/supervisord/supervisord.conf
