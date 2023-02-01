FROM nvidia/cuda:10.2-runtime-ubuntu18.04

RUN apt-get update && \
	apt-get install --no-install-recommends -y python3-pip && \
	ln -sfn /usr/bin/python3.6 /usr/bin/python && \
	ln -sfn /usr/bin/pip3 /usr/bin/pip && rm -rf /var/lib/apt/lists/*;

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN deps='build-essential gdal-bin python-gdal libgdal-dev kmod wget apache2' && \
	apt-get update && \
	apt-get install --no-install-recommends -y $deps && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip && \
	pip install --no-cache-dir GDAL==$(gdal-config --version)

WORKDIR /neo
ADD neat_eo .
RUN pip install --no-cache-dir .

WORKDIR /ada_tools
ADD ada_tools .
RUN pip install --no-cache-dir . && pip install --no-cache-dir torchvision

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8