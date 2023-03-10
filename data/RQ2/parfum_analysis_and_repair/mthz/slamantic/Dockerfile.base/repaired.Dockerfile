FROM conanio/gcc8
USER root
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install --no-install-recommends -y wget libtbb-dev libglew-dev qt5-default libxkbcommon-dev libopencv-dev && rm -rf /var/lib/apt/lists/*;
# libboost-all-dev python-pip libopencv-dev

ADD ./Thirdparty /app/Thirdparty
ADD Vocabulary /app/Vocabulary
ADD ./build_thirdparty.sh /app
RUN cd /app && ./build_thirdparty.sh



