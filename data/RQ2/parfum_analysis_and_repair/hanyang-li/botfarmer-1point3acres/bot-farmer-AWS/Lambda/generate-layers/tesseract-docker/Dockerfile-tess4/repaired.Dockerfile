FROM lambci/lambda-base:build

#Proxy setup if exists
#ENV http_proxy 'http://ip:port'
#ENV https_proxy 'https://ip:port'

ARG LEPTONICA_VERSION=1.78.0
ARG TESSERACT_VERSION=4.1.0-rc4
ARG AUTOCONF_ARCHIVE_VERSION=2017.09.28
ARG TMP_BUILD=/tmp
ARG TESSERACT=/opt/tesseract
ARG LEPTONICA=/opt/leptonica
ARG DIST=/opt/build-dist
# change OCR_LANG to enable the layer for different languages
ARG OCR_LANG=eng
# change TESSERACT_DATA_SUFFIX to use different datafiles (options: "_best", "_fast" and "")
ARG TESSERACT_DATA_SUFFIX=
ARG TESSERACT_DATA_VERSION=4.0.0

RUN yum makecache fast; yum clean all && yum -y update && yum -y upgrade; yum clean all && \
    yum install -y yum-plugin-ovl; rm -rf /var/cache/yum yum clean all && yum -y groupinstall "Development Tools"; yum clean all

RUN yum -y install gcc gcc-c++ make autoconf aclocal automake libtool \
    libjpeg-devel libpng-devel libtiff-devel zlib-devel \
    libzip-devel freetype-devel lcms2-devel libwebp-devel \
    libicu-devel tcl-devel tk-devel pango-devel cairo-devel; rm -rf /var/cache/yum yum clean all

WORKDIR ${TMP_BUILD}/leptonica-build
RUN curl -f -L https://github.com/DanBloomberg/leptonica/releases/download/${LEPTONICA_VERSION}/leptonica-${LEPTONICA_VERSION}.tar.gz | tar xz && cd ${TMP_BUILD}/leptonica-build/leptonica-${LEPTONICA_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${LEPTONICA} && make && make install && cp -r ./src/.libs /opt/liblept

RUN echo "/opt/leptonica/lib" > /etc/ld.so.conf.d/leptonica.conf && ldconfig

WORKDIR ${TMP_BUILD}/autoconf-build
RUN curl -f https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-${AUTOCONF_ARCHIVE_VERSION}.tar.xz | tar xJ && \
    cd autoconf-archive-${AUTOCONF_ARCHIVE_VERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && cp ./m4/* /usr/share/aclocal/

WORKDIR ${TMP_BUILD}/tesseract-build
RUN curl -f -L https://github.com/tesseract-ocr/tesseract/archive/${TESSERACT_VERSION}.tar.gz | tar xz && \
    cd tesseract-${TESSERACT_VERSION} && ./autogen.sh && PKG_CONFIG_PATH=/opt/leptonica/lib/pkgconfig LIBLEPT_HEADERSDIR=/opt/leptonica/include \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=${TESSERACT} --with-extra-includes=/opt/leptonica/include --with-extra-libraries=/opt/leptonica/lib && make && make install

WORKDIR /opt
RUN mkdir -p ${DIST}/lib && mkdir -p ${DIST}/bin && \
    cp ${TESSERACT}/bin/tesseract ${DIST}/bin/ && \
    cp ${TESSERACT}/lib/libtesseract.so.4  ${DIST}/lib/ && \
    cp ${LEPTONICA}/lib/liblept.so.5 ${DIST}/lib/liblept.so.5 && \
    cp /usr/lib64/libwebp.so.4 ${DIST}/lib/ && \
    echo -e "LEPTONICA_VERSION=${LEPTONICA_VERSION}\nTESSERACT_VERSION=${TESSERACT_VERSION}\nTESSERACT_DATA_FILES=tessdata${TESSERACT_DATA_SUFFIX}/${TESSERACT_DATA_VERSION}" > ${DIST}/TESSERACT-README.md && \
    find ${DIST}/lib -name '*.so*' | xargs strip -s

WORKDIR ${DIST}/tesseract/share/tessdata
RUN curl -f -L https://github.com/tesseract-ocr/tessdata${TESSERACT_DATA_SUFFIX}/raw/${TESSERACT_DATA_VERSION}/osd.traineddata > osd.traineddata && \
    curl -f -L https://github.com/tesseract-ocr/tessdata${TESSERACT_DATA_SUFFIX}/raw/${TESSERACT_DATA_VERSION}/eng.traineddata > eng.traineddata && \
    curl -f -L https://github.com/tesseract-ocr/tessdata${TESSERACT_DATA_SUFFIX}/raw/${TESSERACT_DATA_VERSION}/${OCR_LANG}.traineddata > ${OCR_LANG}.traineddata

COPY . ${DIST}/tesseract/share/tessdata/

RUN rm Dockerfile*
RUN rm build_*
RUN rm *.zip; exit 0

WORKDIR /var/task
