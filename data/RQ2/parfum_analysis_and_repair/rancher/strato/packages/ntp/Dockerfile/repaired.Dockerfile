FROM strato-build

ENV LDFLAGS -s
RUN wget -P /usr/src/ https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p9.tar.gz
COPY ntp.conf config.guess config.sub /usr/src/
RUN cd /usr/src/ \
    && tar xf ntp*.tar.gz \
    && cd ntp* \
    && cp ../config.guess ../config.sub sntp/libevent/build-aux && rm ntp*.tar.gz
RUN cd /usr/src/ntp* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr \
    --bindir=/usr/sbin \
    && make

RUN cd /usr/src/ntp* \
    && make install \
    && install -m644 -D /usr/src/ntp.conf /etc/ntp.conf
