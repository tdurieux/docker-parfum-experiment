FROM cd/jenkins-slave-base

MAINTAINER Michael Sauter <michael.sauter@boehringer-ingelheim.com>

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-slave-maven-rhel7-docker" \
      name="openshift3/jenkins-slave-maven-rhel7" \
      version="3.6" \
      architecture="x86_64" \
      release="4" \
      io.k8s.display-name="Jenkins Slave Maven" \
      io.k8s.description="The jenkins slave maven image has the maven tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,maven"

ENV MAVEN_VERSION=3.3 \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    HOME=/home/jenkins \
    GRADLE_USER_HOME=/home/jenkins/.gradle

#set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/jre

# Install Maven
RUN yum install -y wget && \
    wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo && \
    sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo && \
    INSTALL_PKGS="java-11-openjdk-devel apache-maven*" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p $HOME/.m2 && \
    exactVersion=$(ls -lah /usr/lib/jvm | grep java-11-openjdk-11 | awk '{print $NF}' | head -1) && \
    alternatives --set java /usr/lib/jvm/${exactVersion}/bin/java && \
    alternatives --set javac /usr/lib/jvm/${exactVersion}/bin/javac && \
    java -version && \
    javac -version && rm -rf /var/cache/yum

# Container support is now integrated in Java 11, the +UseCGroupMemoryLimitForHeap option has been pruned
ENV JAVA_TOOL_OPTIONS="-XX:+UnlockExperimentalVMOptions -Dsun.zip.disableMemoryMapping=true"

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ADD contrib/bin/scl_enable /usr/local/bin/scl_enable
ADD contrib/bin/configure-slave /usr/local/bin/configure-slave

# set java proxy var
COPY set_maven_proxy.sh /tmp/set_maven_proxy.sh
RUN chmod 777 /tmp/set_maven_proxy.sh

ADD ./contrib/settings.xml $HOME/.m2/
RUN mv $HOME/.m2/settings.xml $HOME/.m2/settings.xml.orig && \
 /tmp/set_maven_proxy.sh && \
 xpr=$(cat /tmp/mvn_proxy) && \
 xpr="${xpr//\//\\/}" && \
 xpr="${xpr//|/\\|}" && \
 cat $HOME/.m2/settings.xml.orig | sed -e "s|<proxies>|<proxies>$xpr|g" > $HOME/.m2/settings.xml && \
 sed -i "s/__NEXUS_USER/$NEXUS_USERNAME/gi" $HOME/.m2/settings.xml && \
 sed -i "s/__NEXUS_PW/$NEXUS_PASSWORD/gi" $HOME/.m2/settings.xml && \
 sed -i "s|__NEXUS_HOST|$NEXUS_HOST|gi" $HOME/.m2/settings.xml && \
 cat $HOME/.m2/settings.xml

# install gradle ..
ADD gradlew /tmp/gradlew
RUN mkdir -p /tmp/gradle/wrapper
ADD gradle/* /tmp/gradle/wrapper
RUN ls /tmp/gradle/wrapper

# set java proxy var
COPY set_gradle_proxy.sh /tmp/set_gradle_proxy.sh
RUN chmod 777 /tmp/set_gradle_proxy.sh

RUN mkdir $GRADLE_USER_HOME
RUN /tmp/set_gradle_proxy.sh

RUN /tmp/gradlew -version

#set java proxy via JAVA_OPTS as src
RUN bash -l -c 'echo export JAVA_OPTS="$(/tmp/set_java_proxy.sh && echo $JAVA_OPTS)" >> /etc/bash.bashrc'

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME
USER 1001

