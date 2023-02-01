FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive 

RUN dpkg --add-architecture i386

RUN apt-get update

RUN apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y lib32z1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl1.0.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y 'libssl1.0.0:i386' && rm -rf /var/lib/apt/lists/*;
RUN ln -s /lib/i386-linux-gnu/libcrypto.so.1.0.0 /lib/i386-linux-gnu/libcrypto.so.4

VOLUME /data

ADD iouyap /bin
RUN chmod 700 /bin/iouyap

RUN mkdir /images
ADD iourc.txt /images
ADD iou.bin /images
RUN chmod 700 /images/iou.bin

ADD boot.sh /
ADD netmap.py /

ENV HOSTNAME=gns3vm

CMD /bin/bash ./boot.sh
