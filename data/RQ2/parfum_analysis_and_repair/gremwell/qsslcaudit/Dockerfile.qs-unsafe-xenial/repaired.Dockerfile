#
# Docker environment for QSSLCAUDIT testing
# Uses binary packages of unsafe OpenSSL
#
# Prepare image: docker build -t qs-unsafe-xenial -f Dockerfile.qs-unsafe-xenial .
# Run instance:  docker run --name qs-unsafe-xenial --rm -it qs-unsafe-xenial
#
FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y wget git time && rm -rf /var/lib/apt/lists/*;

ADD . /qsslcaudit
WORKDIR /qsslcaudit

RUN tools/install-deps-unsafe-xenial.sh
RUN tools/install.sh

RUN apt-get install --no-install-recommends -y curl vim libxml-xpath-perl lsb-release && rm -rf /var/lib/apt/lists/*;

#RUN tools/run-autotests.sh
#RUN tools/run-e2e-tests.sh unsafe
