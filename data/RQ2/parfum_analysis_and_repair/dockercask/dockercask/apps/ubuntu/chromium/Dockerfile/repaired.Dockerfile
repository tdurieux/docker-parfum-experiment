FROM dockercask/base-xorg
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN apt-get install -y --no-install-recommends --assume-yes ffmpeg libgstreamer-plugins-good1.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends --assume-yes chromium-browser && rm -rf /var/lib/apt/lists/*;

ADD init.sh .
CMD ["sh", "init.sh"]
