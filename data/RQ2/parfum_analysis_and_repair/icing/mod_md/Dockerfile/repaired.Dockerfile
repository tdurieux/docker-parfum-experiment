FROM ubuntu:xenial

RUN apt update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL C.UTF-8
RUN add-apt-repository ppa:ondrej/apache2
RUN apt update
RUN apt install --no-install-recommends -y apache2 apache2-dev build-essential autoconf make libtool libssl-dev libjansson-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

COPY . mod_md
WORKDIR mod_md

RUN autoreconf -i
RUN automake
RUN autoconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-apxs=/usr/bin/apxs
RUN make
RUN make install

RUN echo >/etc/apache2/mods-available/md.load "LoadModule md_module /usr/lib/apache2/modules/mod_md.so"
RUN ln -s ../mods-available/md.load /etc/apache2/mods-enabled/md.load

VOLUME /etc/apache
WORKDIR /etc/apache

CMD ["/usr/sbin/apache2", "-d", ".", "-DFOREGROUND"]
