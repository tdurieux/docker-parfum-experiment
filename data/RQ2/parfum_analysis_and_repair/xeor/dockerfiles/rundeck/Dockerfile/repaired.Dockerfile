FROM xeor/base-centos

MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2015-04-12

RUN yum install -y java-1.6.0-openjdk && \
    mkdir /rundeck && cd /rundeck && \
    curl -f -L https://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.4.2.jar > rundeck.jar && \
    java -jar rundeck.jar --installonly && mkdir projects etc server/logs && rm -rf /var/cache/yum

COPY init/ /init/

VOLUME ["/data"]

EXPOSE 4440
