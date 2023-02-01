FROM komand/python-3-plugin:2
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
RUN apt-get update && apt-get install --no-install-recommends ntp -y && rm -rf /var/lib/apt/lists/*;
# End package dependencies
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi
RUN python setup.py build && python setup.py install

ENTRYPOINT ["/usr/local/bin/komand_google_cloud_pub_sub"]