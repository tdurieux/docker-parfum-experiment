FROM ubuntu:16.04

ADD *.deb /pkg/

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV TESSDATA_PREFIX /usr/local/share/tessdata

RUN apt update && \
    apt install -y wget \
                       python3 \
                       python3-pip \
                       libglib3.0 \
                       libpng12-dev \
                       libjpeg8-dev \
                       libtiff5-dev \
                       zlib1g-dev \
                       gdebi-core \
                       python-qt4 && \
    wget -q http://ftp.us.debian.org/debian/pool/main/l/leptonlib/libleptonica-dev_1.74.1-1_amd64.deb && \
    wget -q http://ftp.us.debian.org/debian/pool/main/l/leptonlib/liblept5_1.74.1-1_amd64.deb && \
    wget -q http://ftp.us.debian.org/debian/pool/main/g/giflib/libgif7_5.1.4-0.4_amd64.deb && \
    wget -q http://ftp.us.debian.org/debian/pool/main/libw/libwebp/libwebp6_0.5.2-1_amd64.deb && \
    wget -q http://ftp.us.debian.org/debian/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_1.5.1-2_amd64.deb && \
    gdebi -n libjpeg62-turbo_*.deb && \
    gdebi -n libwebp6_*.deb && \
    gdebi -n libgif7_*.deb && \
    gdebi -n liblept5_*.deb && \
    gdebi -n libleptonica-dev_*.deb && \
    gdebi -n /pkg/leptonica-latest_*.deb && \
    gdebi -n /pkg/tesseract-latest_*.deb && \
    rm -f *.deb && \
    apt remove -y gdebi-core && \
    apt autoremove -y && \
    pip3 install opencv-python opencv-contrib-python flask && \
    # osd: Orientation and script detection
    # equ: Math / Equation detection
    # eng: English
    # other languages: https://github.com/tesseract-ocr/tesseract/wiki/Data-Files
    wget -qO ${TESSDATA_PREFIX}/osd.traineddata https://github.com/tesseract-ocr/tessdata/raw/master/osd.traineddata && \
    wget -qO ${TESSDATA_PREFIX}/equ.traineddata https://github.com/tesseract-ocr/tessdata/raw/master/equ.traineddata && \
    wget -qO ${TESSDATA_PREFIX}/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata

ENV FLASK_APP text-detect.py
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/lib:/lib:/lib64
ENV APP_FOLDER /app
ENV PATH $APP_FOLDER:$PATH

WORKDIR $APP_FOLDER

CMD flask run --host=0.0.0.0
