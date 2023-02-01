FROM centos:6

RUN \
  yum install -y epel-release
RUN \
  yum install -y \
    gcc \
    git \
    libxml2 \
    lua-devel \
    luajit \
    luajit-devel \
    luarocks \
    make \
    m4 \
    openssl-devel \
    unzip
RUN \
  luarocks install cqueues \
    CRYPTO_LIBDIR=/usr/lib64 \
    OPENSSL_LIBDIR=/usr/lib64 && \
  luarocks install luaunit

RUN \
  useradd --user-group --create-home xmlua

COPY . /home/xmlua/xmlua
WORKDIR /home/xmlua/xmlua
RUN \
  cp \
    xmlua.rockspec \
    xmlua-$(grep VERSION xmlua.lua | sed -e 's/.*"\(.*\)"/\1/g')-0.rockspec
RUN \
  luarocks make xmlua-*.rockspec \
    LIBXML2_LIBDIR=/usr/lib64 && \
  mv /usr/lib/lua/5.1/* \
     /usr/lib64/lua/5.1/
RUN rm -rf xmlua.lua xmlua

USER xmlua

RUN \
  git clone --depth 1 https://github.com/clear-code/luacs.git ../luacs

CMD \
  test/run-test.lua && \
  luajit -e 'package.path = "../luacs/?.lua;" .. package.path' \
    sample/parse-html-cqueues-thread.lua sample/sample.html
