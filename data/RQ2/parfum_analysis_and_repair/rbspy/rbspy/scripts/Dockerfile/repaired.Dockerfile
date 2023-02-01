FROM debian:buster

RUN apt-get update
RUN apt-get install --no-install-recommends -y git ruby build-essential autoconf bison libssl-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang libclang-dev curl && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ruby/ruby.git ~/clones/ruby

ENV RUBY_VERSION=3.0.2

WORKDIR /root/clones/ruby
RUN git checkout v${RUBY_VERSION}
RUN autoconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-install-doc
RUN make
RUN make install

RUN git clone https://github.com/rbspy/rbspy.git /opt/rbspy

WORKDIR /opt/rbspy
ENV PATH=~/clones/ruby:${PATH}

RUN curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN ~/.cargo/bin/cargo install bindgen
ENV PATH=~/.cargo/bin:${PATH}

COPY scripts/bindgen.sh /opt/rbspy/scripts/bindgen.sh

CMD bash /opt/rbspy/scripts/bindgen.sh ${RUBY_VERSION}
