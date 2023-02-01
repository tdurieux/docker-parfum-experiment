FROM dockerflow/docker-flow-proxy

RUN apk add --update \
    openssl \
    bash \
    ca-certificates \
  && update-ca-certificates
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk
RUN apk add glibc-2.25-r0.apk

ENV LANG=C.UTF-8


RUN wget https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.4.0-linux-x86_64.tar.gz
RUN tar xzf packetbeat-5.4.0-linux-x86_64.tar.gz
RUN rm packetbeat-5.4.0-linux-x86_64.tar.gz
RUN mv packetbeat-5.4.0-linux-x86_64 /packetbeat
COPY packetbeat.yml /packetbeat/packetbeat.yml
COPY scripts/runner_pbeat.sh /runner_pbeat.sh
RUN chmod +x /runner_pbeat.sh

CMD ["/runner_pbeat.sh"]

