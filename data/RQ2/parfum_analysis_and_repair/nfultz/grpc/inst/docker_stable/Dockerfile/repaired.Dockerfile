FROM rocker/r-devel
MAINTAINER Neal Fultz <nfultz@gmail.com>

## Install grpc and protobuf from deb
RUN apt-get update && apt-get install --no-install-recommends -y \
  r-cran-rprotobuf r-cran-testthat r-cran-rcpp \
  libgrpc6 libgrpc-dev libgrpc++-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

## install R packages
## processx - suggested package for unit testing demo(helloclient)
## remotes - required to installGithub
RUN install.r docopt processx remotes futile.logger
RUN installGithub.r -d FALSE nfultz/grpc && rm -rf /tmp/*
