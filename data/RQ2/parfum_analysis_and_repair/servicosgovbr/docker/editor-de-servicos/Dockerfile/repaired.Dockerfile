FROM centos:centos7

RUN rpm --import http://repos.azulsystems.com/RPM-GPG-KEY-azulsystems
RUN curl -f -s -o /etc/yum.repos.d/zulu.repo https://repos.azulsystems.com/rhel/zulu.repo
RUN yum -y update
RUN yum -y install zulu-8-8.13.0.5-1 && rm -rf /var/cache/yum
RUN curl -f -s -L -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x /usr/bin/jq

ARG SNAP_API_KEY
ARG SNAP_PIPELINE_COUNTER

RUN curl -f -L -u ${SNAP_API_KEY} https://api.snap-ci.com/project/servicosgovbr/editor-de-servicos/branch/master/pipelines/${SNAP_PIPELINE_COUNTER} | jq '.stages[].workers[].artifacts[].download_url' | grep rpm | xargs curl -o editor-de-servicos-latest.rpm -L -u ${SNAP_API_KEY} && yum install -y editor-de-servicos-latest.rpm && rm -rf /var/cache/yum

ADD run.sh /run.sh

EXPOSE 8080
CMD sh /run.sh
