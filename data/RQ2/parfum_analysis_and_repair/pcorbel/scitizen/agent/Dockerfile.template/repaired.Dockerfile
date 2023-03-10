# fetch architecture specific base image
FROM balenalib/%%BALENA_ARCH%%-debian-python:3.9.5-buster-run

# setup application working directory
WORKDIR /app

# setup environment variables
ENV PYTHONUNBUFFERED 1
ENV WAITFOR_VERSION v2.1.3

# prepare dependencies files
COPY packages.txt /tmp/packages.txt
COPY build-packages.txt /tmp/build-packages.txt
COPY requirements.txt /tmp/requirements.txt

# install system dependencies
RUN apt-get update \
 && xargs apt-get install --no-install-recommends --assume-yes --quiet < /tmp/packages.txt \
 && xargs apt-get install --no-install-recommends --assume-yes --quiet < /tmp/build-packages.txt \
 # install wait-for 
 && wget --quiet https://raw.githubusercontent.com/eficode/wait-for/${WAITFOR_VERSION}/wait-for \
 && chmod +x /app/wait-for \
 # install python dependencies
 && pip install --no-cache-dir -r /tmp/requirements.txt \
 # clean up
 && xargs apt-get --yes --purge --auto-remove remove < /tmp/build-packages.txt \
 && apt-get clean \
 && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install app
COPY app/ /app/

# setup entrypoint