# the same as the latest electronuserland/builder:wine as of 2019.01.11
# but with electronuserland/builder:12-11.19 as the parent image
# so that we can use Node v12

FROM electronuserland/builder:12-11.19

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && dpkg --add-architecture i386 && curl -f -L https://dl.winehq.org/wine-builds/winehq.key > winehq.key && apt-key add winehq.key && apt-add-repository https://dl.winehq.org/wine-builds/ubuntu && \
  apt-get update && \
  apt-get -y purge software-properties-common libdbus-glib-1-2 python3-dbus python3-gi python3-pycurl python3-software-properties && \
  apt-get install -y --no-install-recommends winehq-stable && \
  # clean
  apt-get clean && rm -rf /var/lib/apt/lists/* && unlink winehq.key

RUN curl -f -L https://github.com/electron-userland/electron-builder-binaries/releases/download/wine-2.0.3-mac-10.13/wine-home.zip > /tmp/wine-home.zip && unzip /tmp/wine-home.zip -d /root/.wine && unlink /tmp/wine-home.zip

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d
