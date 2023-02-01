FROM --platform=linux/amd64 swift:5.5

RUN apt-get --fix-missing update && apt-get install --no-install-recommends -y cmake libpq-dev libssl-dev libz-dev openssl python && rm -rf /var/lib/apt/lists/*;

WORKDIR /build

COPY .pf-env* ./
COPY Makefile .
COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests

RUN git clone https://github.com/commonmark/cmark \
  && cd cmark \
  && git checkout 1880e6535e335f143f9547494def01c13f2f331b
RUN make -C cmark INSTALL_PREFIX=/usr
RUN make -C cmark install

RUN swift build --build-tests --enable-test-discovery --jobs 1 -Xswiftc -D -Xswiftc OSS

CMD .build/debug/Server
