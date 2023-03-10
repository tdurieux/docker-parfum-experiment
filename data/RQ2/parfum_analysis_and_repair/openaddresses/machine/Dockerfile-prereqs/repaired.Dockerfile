FROM ubuntu:16.04

ENV LC_ALL=C.UTF-8

# Install packages additional Ubuntu PPAs.
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y software-properties-common python-software-properties && \
    add-apt-repository -y ppa:openaddresses/gdal2 && rm -rf /var/lib/apt/lists/*;

# Install needed binary packages for pip installation, openaddr requirements, and Tippecanoe.
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y python3-cairo libgeos-c1v5=3.5.1-3~xenial0 \
        libgdal20=2.1.3+dfsg-1~xenial2 python3-gdal=2.1.3+dfsg-1~xenial2 \
        python3-pip python3-dev libpq-dev memcached libffi-dev \
        gdal-bin=2.1.3+dfsg-1~xenial2 libgdal-dev=2.1.3+dfsg-1~xenial2 && \
    apt-get install --no-install-recommends -y git build-essential libsqlite3-dev protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

# Workaround for https://github.com/pypa/setuptools/issues/2541
ENV PYTHONWARNINGS=ignore:DEPRECATION
RUN pip3 install --no-cache-dir --upgrade 'pip<21' 'setuptools<51'

# Download and install Tippecanoe.
RUN git clone -b 1.34.3 https://github.com/mapbox/tippecanoe.git /tmp/tippecanoe && \
    cd /tmp/tippecanoe && \
    make && \
    PREFIX=/usr/local make install && \
    rm -rf /tmp/tippecanoe

# Pip modules for EC2 user data scripts and docs.
RUN pip3 install --no-cache-dir 'honcho == 1.0.1' 'virtualenv == 15.1.0'
