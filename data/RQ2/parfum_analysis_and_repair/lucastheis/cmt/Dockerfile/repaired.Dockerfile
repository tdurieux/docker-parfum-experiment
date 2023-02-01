FROM ubuntu:18.04
MAINTAINER Lucas Theis

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjpeg-dev libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopenblas-base && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y autoconf automake libtool && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp/
WORKDIR /tmp

RUN pip3 install --no-cache-dir -r requirements.txt

RUN git clone https://github.com/lucastheis/cmt
RUN \
	cd cmt/code/liblbfgs && \
	./autogen.sh && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-sse2 && \
	make CFLAGS="-fPIC"
RUN \
	cd cmt && \
	python2 setup.py build && \
	python2 setup.py install
