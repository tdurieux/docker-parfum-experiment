FROM golang:1.16

WORKDIR /build
ADD ./ /build

RUN apt install -y --no-install-recommends bash && rm -rf /var/lib/apt/lists/*;

RUN make install

ENTRYPOINT ["tbb"]
CMD ["-h"]
