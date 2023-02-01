FROM python:3.9-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y wget build-essential cmake pkg-config libjpeg-dev libtiff5-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev libgtk-3-dev libatlas-base-dev gfortran git && rm -rf /var/lib/apt/lists/*;

ADD ci/docker_dependencies.sh .
RUN ./docker_dependencies.sh

RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir --extra-index-url https://www.piwheels.org/simple/ --prefer-binary opencv-python

COPY . /depthai-python
RUN cd /depthai-python && python3 -m pip install .