FROM ubuntu:xenial

# fixes tzdata asking for timezone
ENV DEBIAN_FRONTEND=noninteractive

# update ...
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \

    cmake \
    build-essential \

    qt5-default \
    qtcreator-dev \
    libqt5svg5-dev \
    libexiv2-dev \

    libopencv-dev \
    libraw-dev \
    libquazip5-dev && rm -rf /var/lib/apt/lists/*;