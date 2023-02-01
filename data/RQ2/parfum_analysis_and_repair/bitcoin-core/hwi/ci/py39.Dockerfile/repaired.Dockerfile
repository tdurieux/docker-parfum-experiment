FROM python:3.9

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    cython3 \
    git \
    libpcsclite-dev \
    libsdl2-dev \
    libsdl2-image-dev \
    libudev-dev \
    libusb-1.0-0-dev \
    qemu-user-static \
    swig && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir poetry flake8

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
