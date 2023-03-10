FROM dockercask/base-xorg
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN dpkg --add-architecture i386
RUN apt-get update
RUN wget https://repo.steampowered.com/steam/archive/precise/steam_latest.deb
RUN dpkg -i steam_latest.deb || true
RUN apt-get install -y --assume-yes -f
RUN apt-get install -y --no-install-recommends --assume-yes libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386 && rm -rf /var/lib/apt/lists/*;

ADD init.sh .
CMD ["sh", "init.sh"]
