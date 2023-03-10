FROM debian:jessie
MAINTAINER Victor Luchits <vluchits@gmail.com>
RUN groupadd -g 1066 buildbot && useradd -u 1066 -g 1066 -r -m buildbot
VOLUME /home/buildbot/tar_gz
ADD . /home/buildbot/qfusion
RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake \
    mingw-w64 \
    sudo && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/buildbot/qfusion/source
RUN sudo chown -R buildbot:buildbot /home/buildbot/qfusion && \
    sudo -u buildbot cmake -DCMAKE_TOOLCHAIN_FILE=cmake/x86_64-mingw.cmake -DQFUSION_TAR_GZ_OUTPUT_DIRECTORY=/home/buildbot/tar_gz . && \
    sudo -u buildbot make clean
USER buildbot
