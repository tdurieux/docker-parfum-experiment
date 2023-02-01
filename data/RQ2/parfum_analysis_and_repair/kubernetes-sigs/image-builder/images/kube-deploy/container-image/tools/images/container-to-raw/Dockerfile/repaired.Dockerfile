FROM debian:buster

RUN apt-get -y update && apt-get install --no-install-recommends --yes parted udev && rm -rf /var/lib/apt/lists/*;

ADD makedisk.sh /makedisk.sh
