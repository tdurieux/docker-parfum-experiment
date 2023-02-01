FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt update \
    && apt-get install --no-install-recommends -y \
    g++ \
    cmake \
    libatlas-base-dev \
    python3 \
    python3-dev \
    python3-pip \
    swig \
    git \
    libhdf5-serial-dev \
    && ln -sf /usr/bin/swig4.0 /usr/bin/swig && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir python-libsbml >=5.17.0

COPY amici.tar.gz /tmp

ENV AMICI_CXXFLAGS -fopenmp
ENV AMICI_LDFLAGS -fopenmp

RUN pip3 install --no-cache-dir -U --upgrade pip wheel \
    && mkdir -p /tmp/amici/ \
    && cd /tmp/amici \
    && tar -xzf ../amici.tar.gz \
    && cd /tmp/amici/python/sdist \
    && python3 setup.py -v sdist \
    && pip3 install --no-cache-dir -v $(ls -t /tmp/amici/python/sdist/dist/amici-*.tar.gz | head -1)[petab,pysb] \
    && rm -rf /tmp && mkdir /tmp && rm ../amici.tar.gz

# RUN pip3 install git+https://github.com/ICB-DCM/pyPESTO.git@develop#egg=pypesto
RUN pip3 install --no-cache-dir pyPESTO jupyter pyswarm dlib
