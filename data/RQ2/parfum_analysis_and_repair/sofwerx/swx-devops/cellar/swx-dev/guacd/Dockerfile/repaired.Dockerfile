FROM guacamole/guacd

RUN yum install -y jq && rm -rf /var/cache/yum

ADD run.sh /run.sh

CMD /run.sh
