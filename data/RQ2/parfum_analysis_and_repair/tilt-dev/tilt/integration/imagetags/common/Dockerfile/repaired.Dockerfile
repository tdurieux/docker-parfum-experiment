FROM busybox

RUN mkdir -p /usr/src/common && rm -rf /usr/src/common

ADD message.txt /usr/src/common/regular
