FROM ubuntu:16.04

ARG uid=1000

RUN apt-get update && \
    apt-get install -y \
      pkg-config \
      libssl-dev \
      libgmp3-dev \
      curl \
      build-essential \
      libsqlite3-dev \
      cmake \
      git \
      python3.5 \
      python3-pip \
      python-setuptools \
      apt-transport-https \
      ca-certificates \
      debhelper \
      wget \
      devscripts \
      libncursesw5-dev \
      libzmq3-dev \
      zip \
      unzip \
      jq

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN pip3 install -U \
	pip \
	setuptools \
	virtualenv \
	twine \
	plumbum \
	deb-pkg-tools

RUN cd /tmp && \
   curl https://download.libsodium.org/libsodium/releases/old/libsodium-1.0.14.tar.gz | tar -xz && \
    cd /tmp/libsodium-1.0.14 && \
    ./configure --disable-shared && \
    make && \
    make install && \
    rm -rf /tmp/libsodium-1.0.14

RUN apt-get update && apt-get install openjdk-8-jdk -y
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN apt-get update && apt-get install -y maven

RUN apt-get install -y zip

RUN useradd -ms /bin/bash -u $uid indy
USER indy

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.31.0
ENV PATH /home/indy/.cargo/bin:$PATH

WORKDIR /home/indy

ARG INDY_VERSION

RUN git clone "https://github.com/hyperledger/indy-sdk.git" "./indy-sdk"

RUN (cd "./indy-sdk" && git checkout "tags/$INDY_VERSION")

RUN (cd "./indy-sdk/libindy" && cargo build --release)
RUN (cd "./indy-sdk/libindy" && cargo build)

USER root

RUN mkdir -p "/libindy/release"
RUN mkdir -p "/libindy/debug"
RUN cp "./indy-sdk/libindy/target/release/libindy.so" "/libindy/release/libindy.so"
RUN cp "./indy-sdk/libindy/target/debug/libindy.so" "/libindy/debug/libindy.so"

RUN cp "/libindy/release/libindy.so" "/usr/local/lib/libindy.so"

USER indy

RUN rm -r "./indy-sdk"

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="libindy"

LABEL org.label-schema.version="${INDY_VERSION}"

CMD /bin/bash