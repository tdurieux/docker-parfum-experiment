FROM lsiobase/alpine:3.13 as builder
# set label
LABEL maintainer="NG6"
WORKDIR /downloads
COPY ReleaseTag  /downloads
COPY install.sh  /downloads
# download bilibili-helper
RUN set -ex \
	&& chmod +x install.sh \
	&& bash install.sh

# bilibili-helper
FROM openjdk:8-jdk-slim-buster
# set label
LABEL maintainer="NG6"
ENV TZ=Asia/Shanghai TASK=1d CRON=false \
    PUID=1026 PGID=100
# copy files
COPY --from=builder /downloads/BILIBILI-HELPER.jar  /app/BILIBILI-HELPER.jar
COPY --from=builder /downloads/s6-overlay/  /
COPY --from=builder /downloads/config.json  /app-conf/config.json
# create abc user
RUN apt -y update && apt -y install tzdata cron \
&&  chmod +x /app/BILIBILI-HELPER.jar \
&&  useradd -u 1000 -U -d /config -s /bin/false abc \
&&  usermod -G users abc  \
&&  echo "**** cleanup ****" \
&&  apt-get clean \
&&  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

COPY root/ /

WORKDIR /app
# volume
VOLUME [ "/config" ]

ENTRYPOINT [ "/init" ]
