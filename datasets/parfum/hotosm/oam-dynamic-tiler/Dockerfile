# See https://github.com/mojodna/docker-gdal22
FROM quay.io/mojodna/gdal22
MAINTAINER Seth Fitzsimmons <seth@mojodna.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    bc \
    build-essential \
    ca-certificates \
    curl \
    cython \
    git \
    jq \
    python-pip \
    python-wheel \
    python-setuptools \
    software-properties-common \
  && curl -sf https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && add-apt-repository -s "deb https://deb.nodesource.com/node_6.x $(lsb_release -c -s) main" \
  && apt-get update \
  && apt-get install --no-install-recommends -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /opt/oam-dynamic-tiler/requirements.txt

WORKDIR /opt/oam-dynamic-tiler

RUN pip install -U numpy && \
  pip install -U --no-binary :all: rasterio>=1.0a6 && \
  pip install -r requirements.txt && \
  pip install -U awscli && \
  rm -rf /root/.cache

COPY package.json /opt/oam-dynamic-tiler/package.json

RUN \
  npm install \
  && rm -rf /root/.npm

ENV PATH=/opt/oam-dynamic-tiler/bin:/opt/oam-dynamic-tiler/node_modules/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CPL_TMPDIR /tmp
ENV CPL_VSIL_CURL_ALLOWED_EXTENSIONS .vrt,.tif,.tiff,.ovr,.msk,.jp2,.tfw,.tifw,.tiffw,.wld,.tab
ENV GDAL_CACHEMAX 512
ENV GDAL_DISABLE_READDIR_ON_OPEN TRUE
ENV VSI_CACHE TRUE
ENV VSI_CACHE_SIZE 536870912
ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

COPY . /opt/oam-dynamic-tiler

# TODO put this in oam-dynamic-tiler-server
# USER nobody
# EXPOSE 8000
# ENTRYPOINT ["gunicorn", "-k", "gevent", "-b", "0.0.0.0", "--access-logfile", "-", "app:app"]
