FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/debian:buster

COPY --from=builder qemu-aarch64-static /usr/bin

ENV PATH="/container/scripts:${PATH}"

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -q -y update \
 && apt-get -q -y install --no-install-recommends runit \
                       \
                       xvfb \
                       x11vnc \

 && apt-get -q --no-install-recommends -y install openbox \
                       ttf-dejavu \

                       haproxy \
                       openssl \
                       openssh-server \
                       sudo \

                       python3 \
                       python3-numpy \
                       sed \
                       wget \
                       rsyslog \

 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

 && ln -s /usr/bin/python3 /usr/bin/python \

 && head -n $(grep -n RULES /etc/rsyslog.conf | cut -d':' -f1) /etc/rsyslog.conf > /etc/rsyslog.conf.new \
 && mv /etc/rsyslog.conf.new /etc/rsyslog.conf \
 && echo '*.*        /dev/stdout' >> /etc/rsyslog.conf \
 && sed -i '/.*imklog*/d' /etc/rsyslog.conf \

 && mkdir -p /run/sshd \

 && adduser --disabled-password -q --gecos '' app \
 && passwd -d app \

 && wget -O novnc.tar.gz https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz \
 && tar xvf novnc.tar.gz \
 && ln -s noVNC-* novnc \

 && ln -s /novnc/vnc_lite.html /novnc/index.html \

 && wget -O websockify.tar.gz https://github.com/novnc/websockify/archive/v0.9.0.tar.gz \
 && tar xvf websockify.tar.gz \
 && ln -s websockify-* websockify \

 && chown app -R /websockify* \
 && chown app -R /no* && rm novnc.tar.gz

VOLUME ["/certs"]

EXPOSE 22 80 443 5900

COPY . /container/

HEALTHCHECK CMD ["docker-healthcheck.sh"]
ENTRYPOINT ["entrypoint.sh"]

CMD [ "runsvdir","-P", "/container/config/runit" ]
