FROM python:2

MAINTAINER Gelnior <gelnior@free.fr>

# Python and build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-setuptools \
    python-pycurl \
    python-imaging \
    build-essential \
    git \
    libxml2-dev \
    libxslt-dev && rm -rf /var/lib/apt/lists/*;

# Install newebe
RUN pip install --no-cache-dir image
RUN pip install --no-cache-dir git+git://github.com/gelnior/newebe.git

# Create folders
RUN mkdir -p /usr/local/etc/newebe/
RUN mkdir -p /usr/local/var/newebe/
RUN mkdir -p /usr/local/var/log/newebe/

EXPOSE 8282
CMD ["newebe_server.py", "--configfile=/usr/local/etc/newebe/config.yaml"]

