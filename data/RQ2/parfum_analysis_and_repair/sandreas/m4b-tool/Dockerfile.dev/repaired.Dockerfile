##############################
#
#   m4b-tool build image
#
##############################
FROM alpine:3.9.2 as build
RUN echo "---- INSTALL BUILD DEPENDENCIES ----" \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache --update --upgrade --virtual=build-dependencies \
    autoconf \
    automake \
    boost-dev \
    build-base \
    gcc \
    git \
    tar \
    fdk-aac-dev \
    wget && \
echo "---- COMPILE SANDREAS MP4V2 (for sort-title, sort-album and sort-author) ----" \
  && cd /tmp/ \
  && wget https://github.com/sandreas/mp4v2/archive/master.zip \
  && unzip master.zip \
  && cd mp4v2-master \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make -j4 && \
  make install && make distclean && \
echo "---- COMPILE FDKAAC ENCODER (executable binary for usage of --audio-profile) ----" \
    && cd /tmp/ \
    && wget https://github.com/nu774/fdkaac/archive/1.0.0.tar.gz \
    && tar xzf 1.0.0.tar.gz \
    && cd fdkaac-1.0.0 \
    && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j4 && make install && rm -rf /tmp/* && \
echo "---- REMOVE BUILD DEPENDENCIES (to keep image small) ----" \
   && apk del --purge build-dependencies && rm -rf /tmp/* && rm 1.0.0.tar.gz

##############################
#
#   m4b-tool development image
#
##############################
FROM alpine:3.9.2

ENV WORKDIR /m4b-tool
ARG M4B_TOOL_DOWNLOAD_LINK="https://github.com/sandreas/m4b-tool/releases/latest/download/m4b-tool.phar"

RUN echo "---- INSTALL RUNTIME PACKAGES ----" && \
  apk add --no-cache --update --upgrade \
  # mp4v2: required libraries
  libstdc++ \
  # m4b-tool: php cli, required extensions and php settings
  php7-cli \
  php7-dom \
  php7-json \
  php7-xml \
  php7-mbstring \
  php7-phar \
  php7-tokenizer \
  php7-xmlwriter \
  && echo "date.timezone = UTC" >> /etc/php7/php.ini \
  # fdkaac: required libaries
  && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
      && apk add --no-cache --update --upgrade fdk-aac-dev


# copy ffmpeg static with libfdk from mwader docker image
COPY --from=mwader/static-ffmpeg:4.1.3-1 /ffmpeg /usr/local/bin/

# copy compiled mp4v2 binaries, libs and fdkaac encoder to runtime image
COPY --from=build /usr/local/bin/mp4* /usr/local/bin/fdkaac /usr/local/bin/
COPY --from=build /usr/local/lib/libmp4v2* /usr/local/lib/



WORKDIR ${WORKDIR}
# CMD ["list"]
ENTRYPOINT ["/bin/ash"]
