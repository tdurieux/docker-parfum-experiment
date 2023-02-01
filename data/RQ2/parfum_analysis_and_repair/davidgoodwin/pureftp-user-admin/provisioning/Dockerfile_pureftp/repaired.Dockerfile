FROM debian:stretch

ARG http_proxy=""
ARG https_proxy=""
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -qq update && apt-get -qqy --no-install-recommends install pure-ftpd-mysql && \
    apt-get clean && rm -Rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

EXPOSE 21

CMD [ "/usr/sbin/pure-ftpd-mysql", "-4", "-l mysql:/tmp/mysql.conf" ]
