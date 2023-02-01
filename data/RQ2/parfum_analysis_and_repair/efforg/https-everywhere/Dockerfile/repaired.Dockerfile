FROM electronicfrontierfoundation/https-everywhere-docker-base
MAINTAINER William Budington "bill@eff.org"
WORKDIR /opt

COPY test/rules/requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt
