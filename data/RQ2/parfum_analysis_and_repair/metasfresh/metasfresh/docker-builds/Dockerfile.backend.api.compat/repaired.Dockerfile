ARG REFNAME=local
FROM metasfresh/metas-api:$REFNAME as api

RUN yum update -y && yum -y install nc && yum -y clean all && rm -rf /var/cache && rm -rf /var/cache/yum

RUN mv /opt/metasfresh/metasfresh-webui-api /opt/metasfresh-webui-api