FROM ubuntu:16.04


COPY . /sortmerna

RUN apt-get update && apt-get install --no-install-recommends -y make g++ zlib1g-dev python2.7 python-pip python-numpy python-scipy python-tk && rm -rf /var/lib/apt/lists/*;

RUN cd /sortmerna && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir scikit-bio==0.2.3
