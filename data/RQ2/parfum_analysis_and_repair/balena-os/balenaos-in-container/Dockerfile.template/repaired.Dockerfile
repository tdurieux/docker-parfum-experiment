# syntax=docker/dockerfile:1.2

ARG OS_VERSION
ARG DEVICE_TYPE=%%BALENA_MACHINE_NAME%%

FROM resin/resinos:${OS_VERSION}-${DEVICE_TYPE}

COPY ./entry.sh /entry.sh
COPY ./conf/systemd-watchdog.conf /etc/systemd/system.conf.d/watchdog.conf

ENV container=docker

VOLUME /mnt/boot \
       /mnt/state \
       /mnt/data

CMD [ "/entry.sh" ]

# avoid display crash on some host systems
RUN rm /lib/systemd/system/sysinit.target.wants/systemd-udev-trigger.service