# https://github.com/OSGeo/gdal/tree/master/gdal/docker
# Image includes python3.8, gdal-python, gdal-bin
FROM osgeo/gdal:ubuntu-small-latest

# Set C.UTF-8 locale as default (Needed by the Click library)
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install pip
RUN apt-get update && apt-get --yes --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

# Create directories for config, data and logs
RUN mkdir --parents .local/share/mapswipe_workers

# Copy mapswipe workers repo from local repo
COPY . .

# Update setuptools and install mapswipe-workers with dependencies (requirements.txt)
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir .

# Don't use a CMD here, this will be defined in docker-compose.yaml
