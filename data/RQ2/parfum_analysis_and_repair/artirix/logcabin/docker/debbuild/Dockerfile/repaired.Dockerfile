# Deb build file
# docker build -t logcabin-debbuild docker/debbuild
# docker run -t -i -e PACKAGE=https://pypi.python.org/packages/package.tar.gz -v $HOME/.gnupg:/root/.gnupg logcabin-debbuild
# CONTAINER=$(docker ps -q -a | head -1)
# docker cp $CONTAINER:/tmp/build/deb_dist/logcabin_1.0.x-1_all.deb .
FROM ubuntu:12.04
MAINTAINER Barnaby Gray <barnaby@pickle.me.uk>

RUN apt-get update && apt-get install --no-install-recommends -y dput python-stdeb devscripts wget && apt-get clean && rm -rf /var/lib/apt/lists/*;
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir versiontools
ADD . /

ENV HOME /root
CMD ./build.sh