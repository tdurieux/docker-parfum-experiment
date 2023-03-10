FROM python:2.7-stretch

ARG USER=firecares
ARG UID=1000
ARG GID=1000
ARG PW=firecares

# Option1: Using unencrypted password/ specifying password
RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | \
      chpasswd

# FIRECARES STUFF:
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
					libmemcached-dev \
        binutils \
        build-essential \
        ca-certificates \
        default-libmysqlclient-dev \
        gdal-bin \
        libcurl4-gnutls-dev \
        libgcrypt20-dev \
        libgdal-dev \
        libgnutls28-dev \
        libproj-dev \
        libssl-dev \
        python-dev \
        python-pycurl \
        screen \
        telnet \
        vim && rm -rf /var/lib/apt/lists/*;

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal
ENV SSL_CERT_DIR=/etc/ssl/certs

RUN update-ca-certificates --fresh

USER root

RUN mkdir -p /webapps/firecares/temp /webapps/firecares/logs/ && \
    chmod -R 0755 /webapps/firecares/ && \
    chmod -R 0777 /webapps/firecares/logs

RUN chown -R ${USER} /webapps

WORKDIR /webapps/firecares/

COPY requirements.txt /webapps/firecares/

RUN chown -R ${USER} /webapps

RUN pip install --no-cache-dir -r requirements.txt
