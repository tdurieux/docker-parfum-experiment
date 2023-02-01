FROM dockercask/base-xorg
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN apt-get install -y --no-install-recommends --assume-yes thunderbird && rm -rf /var/lib/apt/lists/*;

ADD init.sh .
CMD ["sh", "init.sh"]
