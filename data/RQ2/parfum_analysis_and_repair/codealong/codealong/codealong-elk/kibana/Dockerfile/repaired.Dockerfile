FROM docker.elastic.co/kibana/kibana-oss:6.6.0

USER 0

RUN yum -y install epel-release && yum -y update && yum clean all && rm -rf /var/cache/yum
RUN yum -y install nodejs && rm -rf /var/cache/yum
RUN npm install -g elasticdump && npm cache clean --force;

COPY bin /user/local/codealong/bin
COPY data /user/local/codealong/data

USER 1000

CMD ["/user/local/codealong/bin/kibana-codealong"]
