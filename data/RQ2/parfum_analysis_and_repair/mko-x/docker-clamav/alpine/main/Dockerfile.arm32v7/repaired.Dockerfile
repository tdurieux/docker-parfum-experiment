FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm32v7/alpine:3.12 as release
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# copy qmeu
COPY --from=qemu qemu-arm-static /usr/bin

RUN apk add --no-cache bash clamav clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY envconfig.sh /
COPY check.sh /

RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav && \
    chown -R clamav:clamav bootstrap.sh check.sh /etc/clamav && \
    chmod u+x bootstrap.sh check.sh

EXPOSE 3310/tcp

USER clamav

CMD ["/bootstrap.sh"]