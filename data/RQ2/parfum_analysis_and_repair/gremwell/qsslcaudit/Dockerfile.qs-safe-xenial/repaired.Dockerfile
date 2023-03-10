#
# Docker environment for QSSLCAUDIT testing
# Uses standard OpenSSL libraries
#
# Prepare image: docker build -t qs-safe-xenial -f Dockerfile.qs-safe-xenial .
# Run instance:  docker run --name qs-safe-xenial --rm -it qs-safe-xenial
#
FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y wget git time && rm -rf /var/lib/apt/lists/*;

ADD . /qsslcaudit
WORKDIR /qsslcaudit

RUN tools/install-deps-safe-xenial.sh
RUN tools/install.sh

RUN apt-get install --no-install-recommends -y curl vim libxml-xpath-perl lsb-release && rm -rf /var/lib/apt/lists/*;

#RUN tools/run-autotests.sh
#RUN tools/run-e2e-tests.sh safe
