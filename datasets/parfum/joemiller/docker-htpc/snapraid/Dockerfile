FROM ubuntu:20.04

# 2021/09/01 (joe): switched PPA to syprat/snapraid which has latest v11.5.  The official PPA listed on snapraid.it is tikhonov/snapraid but it hasn't been updated in years.

RUN apt-get update -q \
  && apt-get install -qy software-properties-common \
  && add-apt-repository -y ppa:syprat/snapraid \
  && apt-get update -q \
  && apt-get install -qy \
    smartmontools \
    snapraid \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

ENTRYPOINT ["/usr/bin/snapraid"]
