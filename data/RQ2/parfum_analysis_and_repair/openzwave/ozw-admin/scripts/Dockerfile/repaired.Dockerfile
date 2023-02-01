#DockerFile to build a image capabile of Building AppImages. See build.sh for details
FROM ubuntu:xenial
WORKDIR /opt

RUN apt update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:beineri/opt-qt-5.12.8-xenial && \
apt update && apt-get install --no-install-recommends -y qt512-meta-minimal qt512remoteobjects rapidjson-dev git g++ cmake make pkgconf bash python wget joe mc libunwind-dev libcurl4-openssl-dev qt512svg qt512websockets mesa-common-dev libgl1-mesa-dev fuse appstream qt512serialport && \
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
chmod +x linuxdeploy*.AppImage && rm -rf /var/lib/apt/lists/*;
VOLUME /opt/buildfiles
ENTRYPOINT /opt/buildfiles/build.sh