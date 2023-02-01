FROM nvidia/cuda:10.2-runtime-ubuntu18.04

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
	apt-get install --no-install-recommends -y python3-pip && \
	ln -sfn /usr/bin/python3.7 /usr/bin/python && \
	ln -sfn /usr/bin/pip3 /usr/bin/pip && rm -rf /var/lib/apt/lists/*;

RUN deps='build-essential cmake gdal-bin python-gdal libgdal-dev kmod wget apache2 vim apt-utils' && \
	apt-get update && \
	apt-get install --no-install-recommends -y $deps && \
	pip install --no-cache-dir --upgrade pip && \
	pip install --no-cache-dir GDAL==$(gdal-config --version) && rm -rf /var/lib/apt/lists/*;

WORKDIR /abd_model
ADD abd_model .
RUN pip install --no-cache-dir .

WORKDIR /abd_utils
ADD abd_utils .
RUN pip install --no-cache-dir .

WORKDIR /
