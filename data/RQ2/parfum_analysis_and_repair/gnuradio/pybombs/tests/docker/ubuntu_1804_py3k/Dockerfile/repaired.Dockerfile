# Base image
FROM ubuntu:18.04
WORKDIR /pybombs

# Some packages depend on tzdata, which gets stuck if timezone is not set.
# overrideable during build using `--build-arg TZ=America/New_York`.
ARG TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Minimal package installation
RUN apt-get update -qq -y
# ruamel will get installed by setup.py via pip, but this just makes the
# process smoother
RUN apt-get install --no-install-recommends -qq -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y python3-ruamel.yaml && rm -rf /var/lib/apt/lists/*;

# Install PyBOMBS using setuptools
COPY PyBOMBS*.tar.gz /pybombs
RUN tar zxf *.tar.gz && rm *.tar.gz
RUN cd * && python3 setup.py install -q

# Install something
RUN mkdir /prefix
RUN cd /prefix
RUN pybombs -v auto-config
RUN pybombs -v recipes add-defaults
RUN pybombs -v prefix init -a default default
RUN pybombs install gr-osmosdr
