FROM maestro_bin_deps
RUN mkdir -p /var/log/maestro/
COPY . $GOPATH/src/github.com/cpg1111/maestro/
WORKDIR $GOPATH/src/github.com/cpg1111/maestro
ENTRYPOINT ["go", "test"]