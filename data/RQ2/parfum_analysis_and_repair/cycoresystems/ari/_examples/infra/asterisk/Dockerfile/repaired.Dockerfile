FROM debian:8

RUN apt-get update && apt-get install --no-install-recommends -y build-essential openssl libxml2-dev libncurses5-dev uuid-dev sqlite3 libsqlite3-dev pkg-config curl libjansson-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-14.0.0-rc1.tar.gz | tar xz

WORKDIR /asterisk-14.0.0-rc1
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make install; make samples

COPY http.conf /etc/asterisk/http.conf
COPY ari.conf /etc/asterisk/ari.conf
COPY extensions.conf /etc/asterisk/extensions.conf

CMD ["/usr/sbin/asterisk", "-f"]

