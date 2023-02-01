FROM dockercask/base-xorg
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN apt-get install -y --no-install-recommends --assume-yes ffmpeg libgstreamer-plugins-good1.0-0 && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends --assume-yes google-chrome-stable && rm -rf /var/lib/apt/lists/*;

ADD init.sh .
CMD ["sh", "init.sh"]
