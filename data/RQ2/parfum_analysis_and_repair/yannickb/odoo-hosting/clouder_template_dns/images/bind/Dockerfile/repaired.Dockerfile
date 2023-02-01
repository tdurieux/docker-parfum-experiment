FROM clouder/base-ubuntu:16.04
MAINTAINER Yannick Buron yburon@goclouder.net

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y -q install bind9 && rm -rf /var/lib/apt/lists/*;
USER root
CMD /usr/sbin/named -u bind -g