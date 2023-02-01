#
# Docker environment for QSSLCAUDIT testing
# Uses standard OpenSSL libraries
#
# Prepare image: docker build -t qs-safe-bionic -f Dockerfile.qs-safe-bionic .
# Run instance:  docker run --name qs-safe-bionic --rm -it qs-safe-bionic
#
FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y wget git time && rm -rf /var/lib/apt/lists/*;

ADD . /qsslcaudit
WORKDIR /qsslcaudit

RUN tools/install-deps-safe-bionic.sh
RUN tools/install.sh

RUN apt-get install --no-install-recommends -y curl vim libxml-xpath-perl lsb-release && rm -rf /var/lib/apt/lists/*;

#RUN tools/run-autotests.sh
#RUN tools/run-e2e-tests.sh safe
