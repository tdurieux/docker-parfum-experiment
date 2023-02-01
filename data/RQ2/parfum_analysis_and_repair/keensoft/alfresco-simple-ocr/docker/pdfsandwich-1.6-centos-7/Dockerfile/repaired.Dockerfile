FROM centos:centos7
MAINTAINER keensoft

RUN set -x \
    && yum -y install wget gcc gcc-c++ make autoconf automake libtool libjpeg-devel libpng-devel libtiff-devel zlib-devel ocaml ImageMagick ImageMagick-devel && rm -rf /var/cache/yum

RUN set -x \
    && wget https://www.leptonica.com/source/leptonica-1.74.4.tar.gz \
    && tar xvf leptonica-1.74.4.tar.gz \
    && cd leptonica-1.74.4 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install && rm leptonica-1.74.4.tar.gz

RUN set -x \
    && wget https://github.com/tesseract-ocr/tesseract/archive/3.05.00.tar.gz \
    && tar xvf 3.05.00.tar.gz \
    && cd tesseract-3.05.00 \
    && ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && ldconfig && rm 3.05.00.tar.gz

RUN set -x \
    && wget https://github.com/tesseract-ocr/tessdata/archive/3.04.00.tar.gz \
    && tar xvf 3.04.00.tar.gz \
    && mv tessdata-3.04.00/* /usr/local/share/tessdata/ && rm 3.04.00.tar.gz

RUN set -x \
    && wget https://dl.fedoraproject.org/pub/epel/6/x86_64/unpaper-0.3-4.el6.x86_64.rpm \
    && rpm -ivh unpaper-0.3-4.el6.x86_64.rpm

RUN set -x \
    && wget https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.6/pdfsandwich-0.1.6.tar.bz2 \
    && tar xvf pdfsandwich-0.1.6.tar.bz2 \
    && cd pdfsandwich-0.1.6 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install && rm pdfsandwich-0.1.6.tar.bz2

RUN set -x \
    && yum -y install which poppler-utils && rm -rf /var/cache/yum

ENTRYPOINT ["pdfsandwich"]
CMD ["-h"]