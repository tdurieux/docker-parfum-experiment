# Dockerfile for running titiler application with uvicorn server
# Size ~600MB
ARG PYTHON_VERSION=3.9

FROM python:${PYTHON_VERSION}-slim

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

# Ensure root certificates are always updated at evey container build
# and curl is using the latest version of them
RUN mkdir /usr/local/share/ca-certificates/cacert.org
RUN cd /usr/local/share/ca-certificates/cacert.org && curl -f -k -O https://www.cacert.org/certs/root.crt
RUN cd /usr/local/share/ca-certificates/cacert.org && curl -f -k -O https://www.cacert.org/certs/class3.crt
RUN update-ca-certificates
ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

COPY src/titiler/ /tmp/titiler/
RUN pip install /tmp/titiler/core /tmp/titiler/mosaic /tmp/titiler/application["server"] --no-cache-dir --upgrade
RUN rm -rf /tmp/titiler

ENV HOST 0.0.0.0
ENV PORT 80
CMD uvicorn titiler.application.main:app --host ${HOST} --port ${PORT}
