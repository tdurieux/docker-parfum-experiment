FROM debian:unstable-slim

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y vim wget unzip git && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir Pillow

#RUN cd /tmp && wget --no-verbose https://adafruit-circuit-python.s3.amazonaws.com/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
#RUN tar -C /usr --strip-components=1 -xaf /tmp/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2

RUN pip install --no-cache-dir mbed-cli
