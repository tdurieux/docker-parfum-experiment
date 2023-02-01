FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y git cmake libassimp-dev libbullet-dev libsdl2-dev libsdl2-image-dev libfreetype6-dev libtinyxml2-dev libglew-dev build-essential libglm-dev libtinyxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone  --recurse-submodules https://github.com/enginmanap/limonEngine.git /limonEngine
WORKDIR /limonEngine
RUN mkdir -p build
WORKDIR /limonEngine/build
RUN cmake ..
RUN make
WORKDIR /limonEngine
RUN tar cvf build.tar build/
RUN gzip build.tar
