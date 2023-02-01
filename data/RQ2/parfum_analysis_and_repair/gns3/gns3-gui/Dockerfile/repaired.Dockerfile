# Run tests inside a container
FROM ubuntu:18.04
MAINTAINER GNS3 Team

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes python3.6 python3-pyqt5 python3-pip python3-pyqt5.qtsvg python3-pyqt5.qtwebsockets python3.6-dev xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

ADD dev-requirements.txt /dev-requirements.txt
ADD requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /dev-requirements.txt

ADD . /src
WORKDIR /src

CMD xvfb-run python3.6 -m pytest -vv
