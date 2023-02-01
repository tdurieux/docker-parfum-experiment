#Container for compiling and running pacman
#tested on ubuntu 16.04
#docker build -t pacman .
#docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY pacman
FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-mixer-dev desktop-file-utils && rm -rf /var/lib/apt/lists/*;
COPY . /pacman
RUN cd /pacman && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
CMD /usr/local/bin/pacman
