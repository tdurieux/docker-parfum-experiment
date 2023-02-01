FROM alpine
RUN apk apk update
RUN apk add --no-cache build-base
RUN apk add --no-cache gtk+2.0-dev
RUN wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.5/wxWidgets-3.1.5.tar.bz2
RUN tar xvf wxWidgets-3.1.5.tar.bz2 && rm wxWidgets-3.1.5.tar.bz2
WORKDIR  wxWidgets-3.1.5
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-shared --enable-unicode
RUN make install