FROM alpine:3.4
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache tcl bash
RUN apk add --no-cache --virtual egg-deps tcl-dev wget make tar gpgme build-base \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/eggdrop1.6.21.tar.gz \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/eggdrop1.6.21.tar.gz.asc \
  && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-key B0B3D92ABE1D20233A2ECB01DB909F5EE7C0E7F7 \
  && gpg --batch --verify eggdrop1.6.21.tar.gz.asc eggdrop1.6.21.tar.gz \
  && rm eggdrop1.6.21.tar.gz.asc \
  && tar -zxvf eggdrop1.6.21.tar.gz \
  && rm eggdrop1.6.21.tar.gz \
  && ( cd eggdrop1.6.21 \
    && CFLAGS="-std=gnu89" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-tclinc=/usr/include/tcl.h --with-tcllib=/usr/lib/libtcl8.6.so \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop) \
  && rm -rf eggdrop1.6.21 \
  && mkdir /home/eggdrop/eggdrop/data \
  && chown -R eggdrop /home/eggdrop/eggdrop \
  && apk del egg-deps

ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV OWNER=""
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"

WORKDIR /home/eggdrop/eggdrop
EXPOSE 3333
COPY entrypoint.sh /home/eggdrop/eggdrop
COPY docker.tcl /home/eggdrop/eggdrop/scripts/

ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
