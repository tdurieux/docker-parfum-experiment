FROM golang:1.15

# install pyenv
RUN git clone -b v1.2.21 https://github.com/pyenv/pyenv.git /.pyenv
ENV PYENV_ROOT /.pyenv
ENV PATH ${PYENV_ROOT}/bin:${PATH}

# install essentials to build python
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
  build-essential \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  openssl \
  python-dev \
  zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# install python
ENV PYVER 2.7.18
RUN pyenv install ${PYVER}
RUN pyenv global ${PYVER}

# install rbenv
RUN git clone -b v1.1.2 https://github.com/rbenv/rbenv.git /.rbenv
ENV RBENV_ROOT /.rbenv
ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:${PATH}

# install ruby-build
RUN mkdir -p "$(rbenv root)"/plugins
RUN git clone -b v20201225 https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# install ruby
ENV RBVER 2.6.6
RUN rbenv install ${RBVER}
RUN rbenv global ${RBVER}

# install cmake
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# install swig
RUN apt-get install --no-install-recommends -y \
  autoconf \
  automake \
  bison \
  g++ \
  libpcre3-dev \
  libtool \
  yodl && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/swig/swig.git /.swig
RUN cd /.swig && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# test v8eval
ADD . ${GOPATH}/src/github.com/sony/v8eval
WORKDIR ${GOPATH}/src/github.com/sony/v8eval
RUN ./build.sh test
RUN go/build.sh test
RUN python/build.sh test
RUN ruby/build.sh test
