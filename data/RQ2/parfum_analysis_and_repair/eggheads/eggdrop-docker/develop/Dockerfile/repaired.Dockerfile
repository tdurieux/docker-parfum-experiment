FROM alpine:3.15
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

ENV EGGDROP_SHA256 85700bdd1e5e709e7ac44fc4cac3bf06ab674ead4fb1df99f1ba8cb892c27a3c
ENV EGGDROP_COMMIT 6959f1943659db6117b93262d18b27dd98313206

RUN apk --update add --no-cache bash openssl
RUN apk --update add --no-cache --virtual egg-deps wget ca-certificates make tar gpgme build-base openssl-dev \
  && wget "https://prdownloads.sourceforge.net/tcl/tcl8.6.12-src.tar.gz" -O tcl8.6.12-src.tar.gz \
  && tar -zxf tcl8.6.12-src.tar.gz \
  && ( cd tcl8.6.12 \
# Fix Tcl UTF Emoji support
    && sed -i "/define TCL_UTF_MAX/c\#define TCL_UTF_MAX 6" generic/tcl.h \
    && cd unix \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install) \
  && wget "https://github.com/eggheads/eggdrop/archive/$EGGDROP_COMMIT.tar.gz" -O develop.tar.gz \
  && echo "$EGGDROP_SHA256  *develop.tar.gz" | sha256sum -c - \
  && tar -zxf develop.tar.gz \
  && rm develop.tar.gz \
    && ( cd eggdrop-$EGGDROP_COMMIT \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop) \
  && rm -rf eggdrop-$EGGDROP_COMMIT \
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
