FROM python:3.6

RUN wget -O PDFlib-Lite-7.0.5.tar.gz https://www.pdflib.com/binaries/PDFlib/705/PDFlib-Lite-7.0.5p3.tar.gz

RUN tar zxvf PDFlib-Lite-7.0.5.tar.gz && \
  cd PDFlib-Lite-7.0.5p3/ && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && \
  make && \
  make install && rm PDFlib-Lite-7.0.5.tar.gz

ENV LD_LIBRARY_PATH /usr/local/lib

RUN pip install --no-cache-dir jupyter
RUN pip install --no-cache-dir pyvim
RUN pip3 install --no-cache-dir rnftools

EXPOSE 8888

ADD examples /examples
WORKDIR /examples
CMD ipython notebook --ip=0.0.0.0
