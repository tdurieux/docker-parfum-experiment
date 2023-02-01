FROM debian:unstable

MAINTAINER Clint Ruoho clint@wtfismyip.com

RUN apt clean
RUN apt-get -y update && apt-get -y --no-install-recommends install unbound procps util-linux && rm -rf /var/lib/apt/lists/*;

ARG USER_ID=101
ARG GROUP_ID=101

COPY unbound.conf /etc/unbound/unbound.conf

WORKDIR /app
ADD . /app
CMD [ "bash", "unbound.sh" ]
