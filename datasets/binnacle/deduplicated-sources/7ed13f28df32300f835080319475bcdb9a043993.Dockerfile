FROM golang:1.12.2-stretch

ARG TAG=HEAD

WORKDIR /pipehub
RUN git clone https://github.com/pipehub/pipehub.git /pipehub \
  && cd /pipehub \
  && git checkout $TAG

COPY misc/docker/build/entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]