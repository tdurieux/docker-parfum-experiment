FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git libsqlite3-dev libxml2-dev libssl-dev zlib1g-dev autoconf && rm -rf /var/lib/apt/lists/*;

RUN mkdir /wired

ADD . /wired/

WORKDIR /wired
RUN git submodule update --init --remote
RUN bash /wired/libwired/bootstrap

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

RUN sed -i "s/user =.*/user = root/g" /usr/local/wired/etc/wired.conf
RUN sed -i "s/files =.*/files = \/files/g" /usr/local/wired/etc/wired.conf

EXPOSE 4871

CMD ["/usr/local/wired/wired", "-D"]
