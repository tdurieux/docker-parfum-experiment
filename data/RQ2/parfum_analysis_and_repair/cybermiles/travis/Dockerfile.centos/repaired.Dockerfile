# build docker image
# > docker build -t cybermiles/travis:centos -f Dockerfile.centos .
# initialize:
# > docker run --rm -v $HOME/.travis:/travis cybermiles/travis:centos node init --home /travis
# node start:
# > docker run --rm -v $HOME/.travis:/travis -p 26657:26657 -p 8545:8545 cybermiles/travis:centos node start --home /travis
FROM cybermiles/travis-build:centos

# libeni
WORKDIR /app/lib
ENV ENI_LIBRARY_PATH=/app/lib
ENV LD_LIBRARY_PATH=/app/lib

RUN mkdir -p libeni \
  && wget https://github.com/CyberMiles/libeni/releases/download/v1.3.7/libeni-1.3.7_centos-7.tgz -P libeni \
  && tar zxvf libeni/*.tgz -C libeni \
  && cp libeni/*/lib/* . && rm -rf libeni && rm libeni/*.tgz

# travis
WORKDIR /go/src/github.com/CyberMiles/travis
# copy travis source code from local
ADD . .

RUN ENI_LIB=$ENI_LIBRARY_PATH make build && cp build/travis /app/ && cd /app && sha256sum travis > travis.sha256

WORKDIR /app
EXPOSE 8545 26656 26657

ENTRYPOINT ["./travis"]
