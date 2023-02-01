FROM debian:testing-slim

RUN apt-get update && apt-get install --no-install-recommends -y autoconf automake gcc clang \
  libtool libtool-bin make pkg-config libcunit1-dev libssl-dev \
  libgnutls28-dev libmbedtls-dev exuberant-ctags git valgrind \
  graphviz doxygen libxml2-utils xsltproc docbook-xml docbook-xsl asciidoc && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
