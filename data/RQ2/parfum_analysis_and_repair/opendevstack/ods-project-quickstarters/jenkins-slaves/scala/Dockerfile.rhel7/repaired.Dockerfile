FROM cd/jenkins-slave-base

MAINTAINER Clemens Utschig <clemens.utschig-utschig@boehringer-ingelheim.com>

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-slave-nodejs-rhel7-docker" \
      name="openshift3/jenkins-slave-nodejs-rhel7" \
      version="3.6" \
      architecture="x86_64" \
      release="4" \
      io.k8s.display-name="Jenkins Slave Scala" \
      io.k8s.description="The jenkins slave scala image has the scala tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,scala"

ENV HOME=/home/jenkins \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    SBT_CREDENTIALS="$HOME/.sbt/credentials"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN set -x \
    && INSTALL_PKGS="gcc make openssl-devel zlib-devel" \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN yum -y install java-1.8.0-openjdk \
    && alternatives --set java $(alternatives --display java | awk '/family.*x86_64/ { print $1; }') && rm -rf /var/cache/yum

ENV SBT_VERSION=1.1.6

RUN curl -f -O -L https://dl.bintray.com/sbt/rpm/sbt-$SBT_VERSION.rpm && \
     yum -y install sbt-$SBT_VERSION.rpm && rm -rf /var/cache/yum

RUN	mkdir -p $HOME/.sbt/1.0/plugins && \
	mkdir -p $HOME/.sbt/0.13/plugins && \
    mkdir -p /tmp/scala	

# copy nexus config over
COPY sbtconfig/credentials $HOME/.sbt/
COPY sbtconfig/repositories $HOME/.sbt/
COPY sbtconfig/credentials.sbt $HOME/.sbt/1.0/plugins/
COPY sbtconfig/credentials.sbt $HOME/.sbt/0.13/plugins/

# really weird sbt rpm happyness :()
COPY sbtopts /usr/share/sbt-launcher-packaging/conf/sbtopts
COPY sbtopts /usr/share/sbt/conf/sbtopts

# temp test hw scala / -ivy $HOME/.ivy2 -Dsbt.global.base=$HOME/.sbt
COPY test/* /tmp/scala/

RUN cat $HOME/.sbt/repositories | sed -e "s|NEXUS_HOST|$NEXUS_HOST|g" > $HOME/.sbt/repositories.tmp && \
    mv $HOME/.sbt/repositories.tmp $HOME/.sbt/repositories  && \
    NEXUS_SHORT=$(echo $NEXUS_HOST | sed -e "s|https://||g" | sed -e "s|http://||g") && \
    sed -i.bak -e "s|NEXUS_HOST|$NEXUS_SHORT|g" $HOME/.sbt/credentials && \
    sed -i.bak -e "s|NEXUS_USERNAME|$NEXUS_USERNAME|g" $HOME/.sbt/credentials && \
    sed -i.bak -e "s|NEXUS_PASSWORD|$NEXUS_PASSWORD|g" $HOME/.sbt/credentials && \
    rm $HOME/.sbt/credentials.bak && \
    cd /tmp/scala && \
    . /tmp/set_java_proxy.sh && \
    export SBT_OPTS=$JAVA_OPTS" -Duser.home=/home/jenkins" && \
    if [[ $HTTP_PROXY != "" ]]; then echo "HTTPS proxy set - SBT bug - remove nexus repos"; rm $HOME/.sbt/repositories; rm /usr/share/sbt/conf/sbtopts; rm /usr/share/sbt-launcher-packaging/conf/sbtopts; fi && \
    sbt -v run && echo "c" && \
    rm -rf target	

RUN	\
    chgrp -R 0 /usr/share && \
    chmod -R g=u /usr/share && \
    chgrp -R 0 $HOME && \
    chmod -R 777 $HOME && \
	chown -R 1001 $HOME

USER 1001