FROM ubuntu:16.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:nilarimogard/webupd8 && apt-get update && \
    apt-get install -y --no-install-recommends dosfstools winusb udev && rm -rf /var/lib/apt/lists/*;
