FROM rust:slim-buster

# prepare container
RUN apt-get update -y

# install python build dependencies
RUN apt-get install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev git docker-compose && rm -rf /var/lib/apt/lists/*;

# get python
ARG VERSION
RUN echo "Building python version $VERSION"
RUN wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
RUN tar xzvf Python-$VERSION.tgz && rm Python-$VERSION.tgz

# build python
WORKDIR Python-$VERSION
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make
RUN make install

# setup python
RUN cp python /bin
RUN apt-get install --no-install-recommends -y python3-openssl python3-dev && rm -rf /var/lib/apt/lists/*;

# setup rust
ENV CARGO_ROOT /usr/local/cargo
ENV PATH $CARGO_ROOT/bin:$PATH

# echo python and rust versions
RUN python3 --version && \
    cargo --version &&   \
    rustup --version &&  \
    rustc --version
