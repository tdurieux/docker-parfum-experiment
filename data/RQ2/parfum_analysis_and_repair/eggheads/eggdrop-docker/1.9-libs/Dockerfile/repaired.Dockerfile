FROM alpine:3.13
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache tcl bash openssl sqlite-tcl mariadb-connector-c-dev tcl-tls \
  && apk add --no-cache tcl-lib --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
  && apk add --no-cache --virtual egg-deps tcl-dev wget ca-certificates make tar gpgme build-base openssl-dev \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.9/eggdrop-1.9.1.tar.gz \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.9/eggdrop-1.9.1.tar.gz.asc \
  && gpg --batch --keyserver keyserver.ubuntu.com --recv-key E01C240484DE7DBE190FE141E7667DE1D1A39AFF \
  && gpg --batch --verify eggdrop-1.9.1.tar.gz.asc eggdrop-1.9.1.tar.gz \
  && command -v gpgconf > /dev/null \
  && gpgconf --kill all \
  && rm eggdrop-1.9.1.tar.gz.asc \
  && tar -zxvf eggdrop-1.9.1.tar.gz \
  && rm eggdrop-1.9.1.tar.gz \
  && ( cd eggdrop-1.9.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop) \
  && rm -rf eggdrop-1.9.1 \
  && mkdir /home/eggdrop/eggdrop/data \
  && chown -R eggdrop /home/eggdrop/eggdrop

RUN wget https://www.xdobry.de/mysqltcl/mysqltcl-3.052.tar.gz \
  && tar -zxvf mysqltcl-3.052.tar.gz \
  && rm mysqltcl-3.052.tar.gz \
    && ( cd mysqltcl-3.052 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install) \
  && rm -rf mysqltcl-3.052 \
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
