FROM ubuntu:20.04

WORKDIR /root

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install --no-install-recommends -y wget libsqlite3-dev libmysqlclient-dev libpq-dev freetds-dev git squashfs-tools clang-10 libxml2 vim unzip bison build-essential autoconf ruby curl libtool && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/ruby/ruby/archive/refs/tags/v3_1_0.zip && unzip v3_1_0.zip && cd ruby-3_1_0 && touch revision.h && autoconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

ENV CC=/usr/bin/clang-10
ENV CPP=/usr/bin/clang-cpp-10
ENV CXX=/usr/bin/clang+-10
ENV LD=/usr/bin/ld.ll-10

CMD ["bash"]
