# ADS-B/SDR image for armhf architecture. This will NOT work on x86 platforms.
#
# Build an image using this Dockerfile as shown below:
#
#    $ docker build . -t <name>
#
# Start Dump1090 Server in a container based on the newly created image as
# shown below:
#
#    $ docker run -d --privileged -v /dev/bus/usb:/dev/bus/usb -p 30002:30002 <image_id>
#
# Attach to the container to see the ADS-B messages being received from SDR
# as shown below:
#
#    $ docker attach <container_id>
#
# <container_id> is generated when the image is run.
#
FROM resin/rpi-raspbian:jessie-20160831

RUN apt-get update && \
    apt-get -qy --no-install-recommends install curl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade && \
    apt-get dist-upgrade
RUN apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends usbutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends git-core git && rm -rf /var/lib/apt/lists/*;

RUN git clone git://git.osmocom.org/rtl-sdr.git /tmp/rtl-sdr
WORKDIR /tmp/rtl-sdr
RUN cmake ./ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN make
RUN make install
RUN ldconfig

RUN git clone https://github.com/MalcolmRobb/dump1090 /tmp/dump1090
WORKDIR /tmp/dump1090
RUN make

EXPOSE 30002
CMD ["./dump1090", "--raw", "--net"]

