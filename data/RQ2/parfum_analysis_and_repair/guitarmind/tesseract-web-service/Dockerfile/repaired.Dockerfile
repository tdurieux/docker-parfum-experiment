#
# Stand-alone tesseract-ocr web service in python.
#
# Version: 0.0.3
# Developed by Mark Peng (markpeng.ntu at gmail)
#

FROM ubuntu:12.04

MAINTAINER guitarmind

RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  automake \
  autotools-dev \
  build-essential \
  checkinstall \
  libjpeg-dev \
  libpng-dev \
  libtiff-dev \
  libtool \
  python \
  python-imaging \
  python-tornado \
  wget \
  zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir ~/temp \
  && cd ~/temp/ \
  && wget https://www.leptonica.org/source/leptonica-1.69.tar.gz \
  && tar -zxvf leptonica-1.69.tar.gz \
  && cd leptonica-1.69 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && checkinstall \
  && ldconfig && rm leptonica-1.69.tar.gz

RUN cd ~/temp/ \
  && wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02.tar.gz \
  && tar xvf tesseract-ocr-3.02.02.tar.gz \
  && cd tesseract-ocr \
  && ./autogen.sh \
  && mkdir ~/local \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$HOME/local/ \
  && make \
  && make install \
  && cd ~/local/share \
  && wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.eng.tar.gz \
  && tar xvf tesseract-ocr-3.02.eng.tar.gz && rm tesseract-ocr-3.02.02.tar.gz

ENV TESSDATA_PREFIX /root/local/share/tesseract-ocr

RUN mkdir -p /opt/ocr/static

COPY tesseractcapi.py /opt/ocr/tesseractcapi.py
COPY tesseractserver.py /opt/ocr/tesseractserver.py

RUN chmod 755 /opt/ocr/*.py

EXPOSE 1688

WORKDIR /opt/ocr

CMD ["python", "/opt/ocr/tesseractserver.py", "-p", "1688", "-b", "/root/local/lib", "-d", "/root/local/share/tesseract-ocr" ]

