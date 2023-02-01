FROM docker.io/phusion/baseimage:0.9.17
MAINTAINER Xena <xena@yolo-swag.com>

# Update base system
RUN apt-get update && apt-get upgrade -yq \
 && apt-get -yq --no-install-recommends install \
      build-essential \
      autoconf-archive \
      libssl-dev \
      flex \
      bison \
      libsqlite3-dev \
      libtool \
      pkg-config \
 && adduser --system --home /home/ircd ircd \
 && mkdir /home/ircd/src \
 && chmod 777 /home/ircd/src && rm -rf /var/lib/apt/lists/*;

ADD . /home/ircd/src

RUN cd /home/ircd/src; ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/home/ircd/run; make ; make install

ADD doc/example.conf /home/ircd/run/etc/ircd.conf
ADD extra/runit/ircd/ /etc/service/ircd/

RUN chmod -R 777 /home/ircd/run

EXPOSE 6667

CMD /sbin/my_init
