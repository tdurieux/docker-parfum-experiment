FROM openjdk:16-alpine

LABEL maintainer="Reinhard Pointner <rednoah@filebot.net>"


ENV FILEBOT_VERSION 4.9.4
ENV FILEBOT_URL https://get.filebot.net/filebot/FileBot_$FILEBOT_VERSION/FileBot_$FILEBOT_VERSION-portable.tar.xz
ENV FILEBOT_SHA256 7f3d01f4ffd406b94a18f66485e31dff87059d61edf9bad2df3453bf89d5b7da


ENV FILEBOT_HOME /opt/filebot


RUN apk add --update mediainfo chromaprint p7zip unrar \
 && rm -rf /var/cache/apk/*

RUN set -eux \
 ## * fetch portable package
 && wget -O /tmp/filebot.tar.xz "$FILEBOT_URL" \
 && echo "$FILEBOT_SHA256  */tmp/filebot.tar.xz" | sha256sum -c - \
 ## * install application files
 && mkdir -p "$FILEBOT_HOME" \
 && tar --extract --file /tmp/filebot.tar.xz --directory "$FILEBOT_HOME" --verbose \
 && rm -v /tmp/filebot.tar.xz \
 ## * delete incompatible native binaries
 && find /opt/filebot/lib -type f -not -name libjnidispatch.so -delete \
 ## * link /opt/filebot/data -> /data to persist application data files to the persistent data volume
 && ln -s /data /opt/filebot/data


ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Dnet.filebot.archive.extractor=ShellExecutables -Duser.home=$HOME"


ENTRYPOINT ["/opt/filebot/filebot.sh"]
