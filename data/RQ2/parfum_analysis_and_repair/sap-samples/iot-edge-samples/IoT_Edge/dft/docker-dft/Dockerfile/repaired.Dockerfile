FROM alpine:3.14.2
RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
RUN apk update
RUN apk --no-cache --update-cache add automake gcc g++ gfortran subversion python3 python3-dev py3-pip build-base wget freetype-dev libpng-dev openblas-dev tesseract-ocr python3 py3-numpy libressl-dev musl-dev libffi-dev cairo cairo-dev cargo py-cffi rust openssl-dev

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

RUN pip3 install --no-cache-dir paho-mqtt
RUN pip3 install --no-cache-dir times
RUN pip3 install --no-cache-dir pyOpenSSL

RUN pip3 install --no-cache-dir numpy

RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir flask

COPY dft.py .
CMD python3 dft.py
