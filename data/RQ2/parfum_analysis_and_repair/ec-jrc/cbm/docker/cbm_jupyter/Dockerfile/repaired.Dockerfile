# Authors: Guido Lemoine, Konstantinos Anastasakis

FROM jupyter/tensorflow-notebook

USER root

RUN apt-get update -q
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -q
RUN add-apt-repository ppa:ubuntugis/ppa
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y \
    build-essential \
    binutils \
    libproj-dev \
    gdal-bin \
    libgdal-dev \
    python3-gdal \
    python3-numpy \
    python3-scipy \
    python3-tk \
    graphviz \
    python3-dev \
    nano \
    g++ \
    gcc \
    libgdal-dev \
    libxml2-dev \
    libxmlsec1-dev && rm -rf /var/lib/apt/lists/*;

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal"

COPY requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt

EXPOSE 8888

USER jovyan