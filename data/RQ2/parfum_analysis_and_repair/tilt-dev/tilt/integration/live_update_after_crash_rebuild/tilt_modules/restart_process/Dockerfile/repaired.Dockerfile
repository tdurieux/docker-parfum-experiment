FROM alpine/git

RUN apk update && apk add --no-cache make
RUN apk add --no-cache build-base

RUN git clone https://github.com/eradman/entr.git /entr
WORKDIR /entr
RUN git checkout c564e6bdca1dfe2177d1224363cad734158863ad
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; CFLAGS="-static" make install

FROM scratch

COPY --from=0  /usr/local/bin/entr /

ADD tilt-restart-wrapper /
