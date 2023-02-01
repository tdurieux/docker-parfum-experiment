FROM dockercask/base-xorg
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
RUN echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends --assume-yes xdg-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends --assume-yes spotify-client && rm -rf /var/lib/apt/lists/*;

ADD init.sh .
CMD ["sh", "init.sh"]
