FROM python:3.6.8-slim-stretch

WORKDIR /app

ENV LD_LIBRARY_PATH /usr/local/lib

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y cmake git libgtk2.0-dev libblas-dev liblapack-dev \
  && rm -rf /var/lib/apt/lists/*

# install ngt
RUN git clone https://github.com/yahoojapan/NGT.git \
  && cd NGT \
  && git checkout v1.7.6 \
  && mkdir build && cd build \
  && cmake .. \
  && make \
  && make install \
  && ldconfig \
  && cd ../python \
  && pip install --no-cache-dir pybind11 \
  && python setup.py sdist \
  && pip install --no-cache-dir dist/ngt-1.4.0.tar.gz

# install hnsw
RUN git clone https://github.com/nmslib/hnsw.git \
  && cd hnsw/python_bindings \
  && pip install --no-cache-dir numpy pybind11 \
  && python setup.py install

# install faiss
RUN git clone https://github.com/facebookresearch/faiss.git \
  && cd faiss \
  && git checkout v1.4.0 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && make py \
  && cd python \
  && python setup.py install

ARG VERSION
COPY dist/imgdupes-${VERSION}.tar.gz .
RUN pip install --no-cache-dir imgdupes-${VERSION}.tar.gz

ENTRYPOINT ["imgdupes"]
