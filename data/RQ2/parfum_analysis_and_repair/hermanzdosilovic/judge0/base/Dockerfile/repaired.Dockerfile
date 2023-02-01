FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  make \
  software-properties-common \
  wget && rm -rf /var/lib/apt/lists/*;


# Install C
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc-4.7 \
    gcc-4.8 \
    gcc-4.9 \
    gcc-5 \
    gcc && rm -rf /var/lib/apt/lists/*;


# Install Isolate
WORKDIR /tmp
RUN git clone https://github.com/ioi/isolate.git && \
  cd isolate && \
  echo "num_boxes = 2147483647" >> default.cf && \
  make install

ENV BOX_ROOT /var/local/lib/isolate


# Install C++
RUN apt-get install --no-install-recommends -y \
    g++-4.7 \
    g++-4.8 \
    g++-4.9 \
    g++-5 \
    g++ && rm -rf /var/lib/apt/lists/*;


# Install Java
RUN echo | add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    apt-get install --no-install-recommends -y oracle-java6-installer \
                       oracle-java7-installer \
                       oracle-java8-installer && rm -rf /var/lib/apt/lists/*;


# Install Ruby
RUN apt-get install --no-install-recommends -y \
  autoconf \
  bison \
  build-essential \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm3 \
  libgdbm-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
RUN wget https://gd.tuwien.ac.at/languages/ruby/ruby-1.9-stable.tar.gz && \
    tar -xzf ruby-1.9-stable.tar.gz && \
    cd ruby-1.9.3-p448 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /usr/lib/ruby/1.9.3 && \
    make && \
    make install && rm ruby-1.9-stable.tar.gz

WORKDIR /tmp
RUN wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.5.tar.gz && \
    tar -xzf ruby-2.2.5.tar.gz && \
    cd ruby-2.2.5 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /usr/lib/ruby/2.2.5 && \
    make && \
    make install && rm ruby-2.2.5.tar.gz

WORKDIR /tmp
RUN wget https://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz && \
    tar -xzf ruby-2.3.1.tar.gz && \
    cd ruby-2.3.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /usr/lib/ruby/2.3.1 && \
    make && \
    make install && rm ruby-2.3.1.tar.gz

ENV PATH /usr/lib/ruby/2.3.1/bin:$PATH


# Install Python
RUN apt-get install --no-install-recommends -y \
  python \
  python3 && rm -rf /var/lib/apt/lists/*;


# Install Pascal
RUN apt-get install --no-install-recommends -y \
  fp-compiler-3.0.0 && rm -rf /var/lib/apt/lists/*;


# ADD HERE MORE COMPILERS ...

RUN cd /tmp && rm -rf *
WORKDIR /root
