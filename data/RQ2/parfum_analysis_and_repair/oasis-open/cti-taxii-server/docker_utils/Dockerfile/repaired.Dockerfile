FROM python:alpine

COPY . /opt/taxii
WORKDIR /opt/taxii
RUN pip install --no-cache-dir --upgrade pip setuptools \
    && pip install --no-cache-dir pymongo \
    && pip install --no-cache-dir .

# Set up the default configuration files
ARG MEDALLION_CONFFILE=/opt/taxii/medallion.conf
ENV MEDALLION_CONFFILE "${MEDALLION_CONFFILE}"
COPY ./docker_utils/base_config.json "${MEDALLION_CONFFILE}"
ARG MEDALLION_CONFDIR=/opt/taxii/medallion.d/
ENV MEDALLION_CONFDIR "${MEDALLION_CONFDIR}"
COPY ./docker_utils/config.d/ "${MEDALLION_CONFDIR}/"
