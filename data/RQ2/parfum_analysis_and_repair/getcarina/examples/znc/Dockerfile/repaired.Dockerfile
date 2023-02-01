FROM ubuntu:15.04

RUN apt-get update && apt-get install --no-install-recommends -y znc && rm -rf /var/lib/apt/lists/*;
RUN useradd znc

ADD docker-entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default
RUN chmod 644 /znc.conf.default

EXPOSE 6667
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/home/znc/.znc"]
