FROM tensorflow/tensorflow:1.12.0-py3
MAINTAINER ratsgo <ratsgo@naver.com>

RUN apt-get update -y \
 && apt-get install --no-install-recommends -y wget language-pack-ko openjdk-8-jdk curl git-core locales && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y locales language-pack-ko && rm -rf /var/lib/apt/lists/*;
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR:en
ENV LC_ALL ko_KR.UTF-8
RUN locale-gen ko_KR.UTF-8 \
 && update-locale LANG=ko_KR.UTF-8 \
 && dpkg-reconfigure locales

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-all-3.7.1.tar.gz \
 && mkdir /notebooks/protobuf-3.7.1 \
 && tar -zxf protobuf-all-3.7.1.tar.gz \
 && cd /notebooks/protobuf-3.7.1 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && ldconfig && rm protobuf-all-3.7.1.tar.gz

RUN wget https://cmake.org/files/v3.14/cmake-3.14.3-Linux-x86_64.sh \
 && mkdir /opt/cmake \
 && sh cmake-3.14.3-Linux-x86_64.sh --prefix=/opt/cmake --skip-license \
 && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir konlpy cmake

WORKDIR /notebooks
RUN wget https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh \
 && bash mecab.sh
RUN rm -rf /notebooks/*

RUN git clone https://github.com/kakao/khaiii.git \
 && mkdir /notebooks/khaiii/build \
 && cd /notebooks/khaiii/build \
 && cmake .. && make all && make resource && make install && make package_python \
 && cd /notebooks/khaiii/build/package_python \
 && pip install --no-cache-dir . \
 && PATH=$PATH:/notebooks/khaiii/build/lib

RUN pip install --no-cache-dir gensim soynlp soyspacing bokeh networkx selenium lxml pyldavis sentencepiece

WORKDIR /notebooks
RUN git clone http://github.com/stanfordnlp/glove \
 && cd /notebooks/glove && make

WORKDIR /notebooks
RUN git clone https://github.com/facebookresearch/fastText.git \
 && cd /notebooks/fastText && make \
 && pip install --no-cache-dir .

WORKDIR /notebooks
RUN git clone https://github.com/ratsgo/embedding.git \
 && cd /notebooks/embedding/models/swivel \
 && make -f fastprep.mk

RUN mv /notebooks/fastText /notebooks/embedding/models \
 && mv /notebooks/glove /notebooks/embedding/models

WORKDIR /notebooks
RUN apt-get install -y --no-install-recommends fonts-nanum* \
 && rm -rf /usr/share/fonts/truetype/dejavu \
 && fc-cache -fv \
 && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
 && tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
 && mv phantomjs-2.1.1-linux-x86_64 /usr/local/share \
 && rm phantomjs-2.1.1-linux-x86_64.tar.bz2 \
 && ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin && rm -rf /var/lib/apt/lists/*;

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

WORKDIR /notebooks/embedding