FROM ubuntu:22.04 as builder
LABEL maintainer michel.promonet@free.fr
WORKDIR /v4l2web	
COPY . /v4l2web

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates g++ autoconf automake libtool xz-utils cmake make pkg-config git libjsoncpp-dev libjpeg-dev libssl-dev npm \
    && make install && apt-get clean && rm -rf /var/lib/apt/lists/

FROM ubuntu:22.04
COPY --from=builder /usr/bin/ /usr/bin/
COPY --from=builder /usr/share/v4l2web/ /usr/share/v4l2web/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates libjsoncpp-dev libjpeg-dev libssl-dev

ENTRYPOINT [ "/usr/bin/v4l2web" ]
CMD [ "-p", "/usr/share/v4l2web/webroot" ]
