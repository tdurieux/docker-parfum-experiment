FROM golang as builder

RUN apt-get update && apt-get install --no-install-recommends -y \
    bzip2 \
    libjansson-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/maxux/

RUN git clone https://github.com/maxux/librtinfo.git && cd librtinfo/linux && make && make install

RUN git clone https://github.com/maxux/rtinfo.git
RUN cd rtinfo/rtinfod && make STATIC=1


FROM alpine

COPY --from=builder /go/src/github.com/maxux/rtinfo/rtinfod/rtinfod /bin

EXPOSE 8089 9930

CMD ["rtinfod", "--verbose", "--client-port", "9930", "--remote-port", "8089"]
