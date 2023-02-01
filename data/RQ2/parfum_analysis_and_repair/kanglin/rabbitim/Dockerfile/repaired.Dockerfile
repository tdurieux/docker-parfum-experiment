#https://github.com/widuu/chinese_docker/blob/master/userguide/dockerimages.md

FROM ubuntu

MAINTAINER KangLin <kl222@126.com>

RUN apt-get update && apt-get -y --no-install-recommends install g++ cmake git subversion wget ant && rm -rf /var/lib/apt/lists/*;

RUN cd /home; \
    git clone https://github.com/KangLin/rabbitim.git; \
    cd rabbitim; \
    export BUILD_TARGERT=unix; \
    export QMAKE=qmake;
    ./ThirdLibrary/build_script/travis/build_depends.sh; \
    ./ThirdLibrary/build_script/travis/build-before.sh; \
    ./ThirdLibrary/build_script/travis/build-and-test.sh


