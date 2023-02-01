# build stage
FROM alpine:3.7 AS packager

RUN \
    apk add --no-cache cmake autoconf make musl-dev gcc g++ openssl openssl-dev git cunit cunit-dev automake libtool util-linux-dev && \
    mkdir -p /build

RUN cd /build && \
    git clone https://github.com/Comcast/parodus2mockTr181.git && \
    cd parodus2mockTr181 && \
    mkdir build && \
    cd build && \
    cmake .. && make && \
    cd /build && \
    git clone https://github.com/Comcast/parodus.git && \
    cd parodus && \
    git checkout ad2d43b4f6e980a6cc1c1340fc82564104eb1dd8 && \
    mkdir build && \
    cd build && \
    cmake .. && make && \
    cd /build && \
    git clone https://github.com/Comcast/aker.git && \
    cd aker && \
    git checkout cfb54022fa6e0ba70040e419d34655da955637b5 && \
    mkdir build && \
    cd build && \
    cmake .. && make

# build image
FROM alpine:3.7

WORKDIR /
COPY --from=packager /build/parodus2mockTr181/build/src/mock_tr181 /usr/bin/
COPY --from=packager /build/aker/build/src/aker /usr/bin/
COPY --from=packager /build/parodus2mockTr181/etc/mock_tr181.json /etc/mock_tr181.json
COPY --from=packager /build/parodus2mockTr181/build/_install/lib/libwdmp-c.so /usr/lib/
COPY --from=packager /build/parodus2mockTr181/build/_install/lib/liblibparodus.so /usr/lib/
COPY --from=packager /build/parodus/build/src/parodus /usr/bin/
COPY --from=packager /build/parodus/build/_install/lib/libcimplog.so.1.0.0 /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib64/libcjson.so.1.7.8 /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib/libcjwt.so /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib/libmsgpackc.so.2.0.0 /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib/libnopoll.so.0.0.0 /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib/libtrower-base64.so.1.0.0 /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib/libwrp-c.so /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib64/libnanomsg.so.5.1.0 /usr/lib/
COPY --from=packager /build/parodus/build/_install/lib64/libcurl.so /usr/lib/
COPY ./simulate /usr/bin/simulate
RUN chmod uga+x /usr/bin/simulate && \
    apk add --no-cache openssl libuuid && \
    ln -s /usr/lib/libcurl.so /usr/lib/libcurl.so.1 && \
    ln -s /usr/lib/libmsgpackc.so.2.0.0 /usr/lib/libmsgpackc.so && \
    ln -s /usr/lib/libmsgpackc.so.2.0.0 /usr/lib/libmsgpackc.so.2 && \
    ln -s /usr/lib/libtrower-base64.so.1.0.0 /usr/lib/libtrower-base64.so && \
    ln -s /usr/lib/libnopoll.so.0.0.0 /usr/lib/libnopoll.so && \
    ln -s /usr/lib/libnopoll.so.0.0.0 /usr/lib/libnopoll.so.0 && \
    ln -s /usr/lib/libcimplog.so.1.0.0 /usr/lib/libcimplog.so && \
    ln -s /usr/lib/libnanomsg.so.5.1.0 /usr/lib/libnanomsg.so.5 && \
    ln -s /usr/lib/libnanomsg.so.5 /usr/lib/libnanomsg.so && \
    ln -s /usr/lib/libcjson.so.1.7.8 /usr/lib/libcjson.so.1 && \
    ln -s /usr/lib/libcjson.so.1 /usr/lib/libcjson.so
ENTRYPOINT [ "/usr/bin/simulate" ]
