# build command: docker build -t 1a1a11a/mimircache -f dockerfileLocal .
# push command: docker push 1a1a11a/mimircache

# the difference between this file and DockerfileEnv is that this one contains mimircache in the container

FROM ubuntu:14.04
LABEL maintainer="peter.waynechina@gmail.com"

ADD testData /mimircache/testData
WORKDIR /mimircache/scripts

# dependency
RUN apt-get -yqq update && apt-get -yqq --no-install-recommends install python3-pip python3-matplotlib libglib2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir mimircache



# sudo docker run -it --rm -v $(pwd):/mimircache/scripts 1a1a11a/mimircache /bin/bash

