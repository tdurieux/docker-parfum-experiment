FROM cloudnautique/hadoop-config:latest

ADD ./conf.d /etc/confd/conf.d
ADD ./templates /etc/confd/templates

VOLUME ["/etc/hadoop"]

ENTRYPOINT ["/confd"]
CMD ["--backend", "rancher", "--prefix", "/2015-07-25"]