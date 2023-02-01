FROM debian:latest
LABEL maintainer "Pascal Meunier @milhouse1337"

# ENV TZ "America/Montreal"

ENV DEBIAN_FRONTEND noninteractive

# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3-setuptools \
    python3-pip \
    python-numpy \
    gdal-bin \
    libgdal-dev \
    libsm6 \
    libxext6 \
    libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir numpy GDAL==$(gdal-config --version)
RUN pip install --no-cache-dir opencv-python
RUN pip install --no-cache-dir felicette

WORKDIR /root

CMD ["/usr/local/bin/felicette"]
