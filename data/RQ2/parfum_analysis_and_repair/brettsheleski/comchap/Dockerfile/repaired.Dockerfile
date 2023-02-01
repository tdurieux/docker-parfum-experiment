FROM alpine:3.14

WORKDIR /

RUN apk --no-cache add ffmpeg tzdata bash \
&& apk --no-cache add --virtual=builddeps autoconf automake libtool git ffmpeg-dev wget tar build-base \
&& wget https://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz \
&& tar xzf argtable2-13.tar.gz \
&& cd argtable2-13/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
&& git clone git://github.com/erikkaashoek/Comskip.git /tmp/comskip \
&& cd /tmp/comskip && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
&& mkdir -p /config && touch /config/comskip.ini \
&& apk del builddeps \
&& cd ~ \
&& rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]* && rm argtable2-13.tar.gz

COPY /comchap /usr/local/bin/comchap
COPY /comcut /usr/local/bin/comcut

