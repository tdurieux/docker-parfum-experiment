FROM jenkins/jenkins:2.127-alpine

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false \
               -Dhudson.model.User.allowNonExistentUser=true"

USER root
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.5/main > /etc/apk/repositories; \
echo http://mirrors.ustc.edu.cn/alpine/v3.5/community >> /etc/apk/repositories; \
apk --no-cache add docker bash

RUN sed -i 's/^jenkins\:x\:1000\:jenkins/jenkins\:x\:1000\:/' /etc/group
RUN sed -i 's/^root\:x\:0\:root/root\:x\:0\:root\,jenkins/' /etc/group

ADD make/release/container/jenkins/jobs /var/jenkins_home/jobs

VOLUME /var/jenkins_home/jobs

ADD make/release/container/jenkins/plugins.txt /usr/share/jenkins/plugins.txt

ENV JENKINS_UC_DOWNLOAD=https://mirrors.tuna.tsinghua.edu.cn/jenkins

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt