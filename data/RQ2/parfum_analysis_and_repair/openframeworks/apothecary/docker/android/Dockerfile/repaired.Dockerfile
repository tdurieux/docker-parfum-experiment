# Based on https://docs.travis-ci.com/user/common-build-problems/#Troubleshooting-Locally-in-a-Docker-Image
FROM travisci/ci-garnet:packer-1513287432-2ffda03

ENV TRAVIS_BUILD_DIR /root
ENV TARGET=android

# Install more recent version of cmake
# Version 3.9.2 taken from https://docs.travis-ci.com/user/build-environment-updates/2017-12-12/
RUN wget https://www.cmake.org/files/v3.9/cmake-3.9.2.tar.gz
RUN tar xf cmake-3.9.2.tar.gz && rm cmake-3.9.2.tar.gz
RUN cd cmake-3.9.2; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make -j12; make install
RUN cmake --version

RUN sudo apt-get update -q
RUN sudo apt-get install --no-install-recommends -y libboost-tools-dev gperf realpath && rm -rf /var/lib/apt/lists/*;


# Run install.sh installing ndk
ADD scripts/ /root/scripts/
RUN chmod +x $TRAVIS_BUILD_DIR/scripts/android/install.sh
RUN cd $TRAVIS_BUILD_DIR; ./scripts/android/install.sh