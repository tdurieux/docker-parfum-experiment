FROM python:3.6.5-stretch
MAINTAINER Sandeep Srinivasa "sss@lambdacurry.com"
ENV DEBIAN_FRONTEND noninteractive


RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir Pillow
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf automake libtool \
    rsync \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.leptonica.org/source/leptonica-1.73.tar.gz -O /tmp/leptonica.tar.gz && tar -xvf /tmp/leptonica.tar.gz --directory /tmp && rm /tmp/leptonica.tar.gz
ARG CACHE_DATE=2016-01-01
WORKDIR /tmp/leptonica-1.73
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
WORKDIR /tmp
RUN wget https://github.com/tesseract-ocr/tesseract/archive/3.04.01.tar.gz -O /tmp/tesseract.tar.gz && tar -xvf /tmp/tesseract.tar.gz --directory /tmp && rm /tmp/tesseract.tar.gz
WORKDIR /tmp/tesseract-3.04.01
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && LDFLAGS=\"-L/usr/local/lib\" CFLAGS=\"-I/usr/local/include\" make && make install && ldconfig
RUN wget https://github.com/tesseract-ocr/tessdata/archive/4.00.tar.gz -O /tmp/tessdata.tgz
RUN tar -xvf /tmp/tessdata.tgz --directory /tmp && rm /tmp/tessdata.tgz
WORKDIR /tmp
RUN  mkdir -p /usr/local/share/tessdata/ &&  rsync -a tessdata-4.00/ /usr/local/share/tessdata
RUN mkdir /tmp/tesserocr

ADD setup.py README.rst tesseract.pxd tesserocr_experiment.pyx tesserocr.pyx tests/ tox.ini /tmp/tesserocr/
WORKDIR /tmp/tesserocr
RUN python setup.py bdist_wheel
RUN python setup.py install

RUN pip install --no-cache-dir numpy Pillow opencv-python