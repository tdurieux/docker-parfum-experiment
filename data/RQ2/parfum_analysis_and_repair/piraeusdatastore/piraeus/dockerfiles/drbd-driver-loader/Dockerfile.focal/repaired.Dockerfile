FROM ubuntu:focal
MAINTAINER Roland Kammerer <roland.kammerer@linbit.com>

ARG DRBD_VERSION

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y kmod gnupg wget make gcc patch curl && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN wget https://pkg.linbit.com/downloads/drbd/9/drbd-${DRBD_VERSION}.tar.gz -O /drbd.tar.gz && \
    wget https://raw.githubusercontent.com/LINBIT/drbd/master/docker/entry.sh -O /entry.sh && chmod +x /entry.sh

ENV LB_HOW compile
ENTRYPOINT /entry.sh
