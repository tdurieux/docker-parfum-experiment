FROM rapid7/insightconnect-python-3-38-slim-plugin:4
LABEL organization=komand
LABEL sdk=python
LABEL type=plugin

ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR /etc/ssl/certs
ENV REQUESTS_CA_BUNDLE  /etc/ssl/certs/ca-certificates.crt

ADD ./plugin.spec.yaml /plugin.spec.yaml
ADD . /python/src

WORKDIR /python/src
# Add any package dependencies here

RUN apk add --no-cache --virtual build-dependencies gcc linux-headers libc-dev libffi-dev build-base openssl-dev python-dev

# End package dependencies
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi
RUN python setup.py build && python setup.py install

ENTRYPOINT ["/usr/local/bin/komand_datetime"]
