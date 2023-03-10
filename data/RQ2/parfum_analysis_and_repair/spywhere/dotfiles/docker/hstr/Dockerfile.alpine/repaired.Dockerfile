FROM alpine AS builder
WORKDIR /etc/app
RUN apk add --no-cache git build-base pkgconfig automake autoconf readline-dev ncurses-dev ncurses-libs
RUN git clone https://github.com/dvorka/hstr hstr
RUN apk add --no-cache sed
WORKDIR /etc/app/hstr/src/include
RUN sed 's/ncursesw\/curses/ncurses/g' -i hstr_curses.h
RUN sed 's/ncursesw\/curses/ncurses/g' -i hstr.h
WORKDIR /etc/app/hstr/build/tarball
RUN sh ./tarball-automake.sh
WORKDIR /etc/app/hstr
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

FROM alpine
COPY --from=builder /usr/local/bin/hstr /usr/bin/hstr
LABEL DEPS="apk add --no-cache ncurses-libs readline"
RUN apk add --no-cache ncurses-libs readline
LABEL BINARY="hstr"
LABEL TEST="--version"
CMD hstr
