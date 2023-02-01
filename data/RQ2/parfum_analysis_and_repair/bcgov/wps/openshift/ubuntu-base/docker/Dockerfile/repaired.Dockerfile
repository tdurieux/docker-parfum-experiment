# When building in openshift, you can reference the image in openshift:
# FROM image-registry.openshift-image-registry.svc:5000/e1e498-tools/ubuntu:20.04

# When building local, you can reference the docker image:
FROM ubuntu:20.04

# Install GDAL
RUN apt-get -y update
RUN apt-get -y upgrade
RUN TZ="Etc/UTC" DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install libgdal-dev && rm -rf /var/lib/apt/lists/*;

# Install R
RUN apt-get update --fix-missing && apt-get -y --no-install-recommends install r-base && rm -rf /var/lib/apt/lists/*;

# Install cffdrs
RUN R -e "install.packages('cffdrs')"

RUN apt-get -y --no-install-recommends install python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

# python3-pip doesn't necessarily get you the latest version of pip.
RUN pip3 install --no-cache-dir --upgrade pip

# According to the stackexchange thread below, we need to install numpy before
# installing gdal or we could end up missing _gdal_array
# https://gis.stackexchange.com/questions/153199/import-error-no-module-named-gdal-array
RUN python3 -m pip install numpy

# Install gdal
# We don't have much control over what version of gdal we're getting, it's pretty much whatever is
# available to us. As such, gdal is not installed by poetry, since the version will differ between
# platforms.
RUN python3 -m pip install gdal==$(gdal-config --version)

# Install poetry https://python-poetry.org/docs/#installation
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && \
    curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py > install-poetry.py && \
    POETRY_HOME=/opt/poetry python3 install-poetry.py --version 1.1.11 && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false && \
    poetry config experimental.new-installer false