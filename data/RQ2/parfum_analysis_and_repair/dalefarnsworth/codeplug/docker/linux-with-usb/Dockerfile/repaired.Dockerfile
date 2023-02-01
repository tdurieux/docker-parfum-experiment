FROM therecipe/qt:linux

MAINTAINER Dale Farnsworth

RUN apt-get update \
    && apt-get -y --no-install-recommends install libusb-1.0 && rm -rf /var/lib/apt/lists/*;
