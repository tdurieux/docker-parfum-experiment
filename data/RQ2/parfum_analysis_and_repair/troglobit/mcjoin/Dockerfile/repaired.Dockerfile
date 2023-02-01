FROM alpine:3.12
RUN apk add --no-cache --update git build-base automake autoconf

RUN git clone --depth=1 https://github.com/troglobit/mcjoin.git /root/mcjoin
WORKDIR /root/mcjoin

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr
RUN make

FROM alpine:3.12
COPY --from=0 /root/mcjoin/src/mcjoin /usr/bin/mcjoin

CMD [ "/usr/bin/mcjoin" ]
