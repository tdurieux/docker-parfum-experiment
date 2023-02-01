# docker run -it branch14/icecast2 /bin/bash

FROM debian:stretch-backports

MAINTAINER Phil Hofmann "phil@voicerepublic.com"

ENV DEBIAN_FRONTEND noninteractive

# add our user and group first to make sure their IDs get assigned
# consistently, regardless of whatever dependencies get added
RUN groupadd -r icecast && \
  useradd -r -g icecast icecast2

RUN apt-get -qq -y update && \
  apt-get -qq --no-install-recommends -y install curl build-essential dpkg-dev libssl-dev jq && rm -rf /var/lib/apt/lists/*;

RUN echo "deb-src http://deb.debian.org/debian stretch main" \
  >> /etc/apt/sources.list

RUN apt-get -qq -y update && \
      apt-get -qq -y build-dep icecast2 && \
      apt-get -qq -y source icecast2

RUN (cd icecast2-2.4.2; dpkg-buildpackage -b)
RUN dpkg -i icecast2_2.4.2-1_amd64.deb

RUN apt-get -qq --no-install-recommends -y install liquidsoap \
  liquidsoap-plugin-mad \
  liquidsoap-plugin-lame \
  liquidsoap-plugin-vorbis \
  liquidsoap-plugin-icecast \
  liquidsoap-plugin-faad && rm -rf /var/lib/apt/lists/*;

RUN apt-get -qq --no-install-recommends -y install python-pip && \
    pip install --no-cache-dir awscli && rm -rf /var/lib/apt/lists/*;

RUN apt-get -qq --no-install-recommends -y install procps && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

RUN mkdir /share && \
    chown -R icecast2:icecast /share

EXPOSE 8080
EXPOSE 8443

VOLUME /share

ADD ./*.sh /
ADD ./*.liq /
ADD ./*.wav /

ADD redirect.html /usr/share/icecast2/web/
ADD loop.mp3 /usr/share/icecast2/web/

RUN chown -R icecast2: /etc/icecast2
RUN mkdir -p /home/icecast2
RUN chown -R icecast2: /home/icecast2

USER icecast2

CMD ["/start.sh"]
