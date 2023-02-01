FROM ubuntu:20.04
MAINTAINER Musa Morena Marcusso Manhaes <musa.marcusso@de.bosch.com>

# Use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends \
    python3-pip \
    libspatialindex-dev \
    libgeos-dev \
    wget \
    libfcl-dev \
    pybind11-dev \
    liboctomap-dev \
    blender \
    pandoc -y && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install pip --upgrade
RUN pip3 install --no-cache-dir flake8 autopep8

COPY . /tmp/pcg_gazebo

WORKDIR /tmp/pcg_gazebo

RUN autopep8 --recursive --aggressive --diff --exit-code /tmp/pcg_gazebo/pcg_gazebo
RUN autopep8 --recursive --aggressive --diff --exit-code /tmp/pcg_gazebo/scripts
RUN autopep8 --recursive --aggressive --diff --exit-code /tmp/pcg_gazebo/tests

RUN flake8 /tmp/pcg_gazebo/pcg_gazebo
RUN flake8 /tmp/pcg_gazebo/scripts
RUN flake8 /tmp/pcg_gazebo/tests

RUN pip3 install --no-cache-dir -e .[all]

RUN python3 -c "import pcg_gazebo"

RUN pytest -v -x /tmp/pcg_gazebo/tests