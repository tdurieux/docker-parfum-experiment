FROM maestro_c
COPY . /go/src/github.com/cpg1111/maestro/
WORKDIR /go/src/github.com/cpg1111/maestro/
RUN make && make install
ENV PATH $PATH:$GOPATH/bin
WORKDIR /go/src/github.com/cpg1111/maestro/
ENTRYPOINT ["maestro"]