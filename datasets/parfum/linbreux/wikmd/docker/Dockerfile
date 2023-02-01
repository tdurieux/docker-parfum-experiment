FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

COPY . /app/wikmd

RUN \
  echo "**** install wikmd dependencies ****" && \
  apt-get update -y && \
  apt-get install -y python3-pip python3-dev pandoc git && \
  # echo "**** install wikmd ****" && \
  # WIKMD_RELEASE=$(curl -sX GET https://api.github.com/repos/Linbreux/wikmd/releases/latest \
  #   | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||') && \
  # mkdir -p /app/wikmd && \
  # curl -o \
  #   /tmp/wikmd.tar.gz -L \
  #   https://github.com/Linbreux/wikmd/archive/master.tar.gz && \
  #   #"https://github.com/Linbreux/wikmd/archive/refs/tags/v${WIKMD_RELEASE}.tar.gz" && \
  # tar xf /tmp/wikmd.tar.gz -C \
  #   /app/wikmd --strip-components=1 && \
  # cp -R . /app/wikmd && \
  echo "**** install pip requirements ****" && \
  cd /app/wikmd && \
  pip3 install -r requirements.txt && \
  echo "**** cleanup ****" && \
  apt-get -y purge \
    python3-pip && \
  apt-get -y autoremove && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache

COPY docker/root/ /

ENV LANG=C.UTF-8
ENV HOME=/wiki

# ports and volumes
EXPOSE 5000
