FROM opendevstackorg/ods-jenkins-agent-base-ubi8:latest

LABEL maintainer="Sebastian Titakis <sebastian.titakis@boehringer-ingelheim.com>"

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-agent-maven-35-rhel7-container" \
      name="openshift4/jenkins-agent-maven-35-rhel7" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Maven" \
      io.k8s.description="The jenkins agent maven image has the maven tools and gradle tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,agent,maven" \
      maintainer="openshift-dev-services+jenkins@redhat.com"

ARG nexusUrl
ARG nexusUsername
ARG nexusPassword

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    MAVEN_OPTS="-Duser.home=$HOME" \
    GRADLE_USER_HOME=/home/jenkins/.gradle
# TODO: Remove MAVEN_OPTS env once cri-o pushes the $HOME variable in /etc/passwd

# Container support is now integrated in Java 11, the +UseCGroupMemoryLimitForHeap option has been pruned
ENV JAVA_TOOL_OPTIONS="-XX:+UnlockExperimentalVMOptions -Dsun.zip.disableMemoryMapping=true"

# Workaroud we use when running behind proxy
# Basically we put the proxy certificate in certs folder
# COPY certs/* /etc/pki/ca-trust/source/anchors/
# RUN update-ca-trust force-enable && update-ca-trust extract


COPY yum.repos.d/* /etc/yum.repos.d/
RUN sh -c "echo 'rhel' > /etc/yum/vars/osname" && \
    sed -i 's@^\s*enabled\s*=.*$@enabled = 1@g' /etc/yum.repos.d/*.repo && \
    sed -i 's@^\s*enabled\s*=.*$@enabled = 0@g' /etc/yum.repos.d/centos8.repo && \
    sed -i 's@^\s*enabled\s*=.*$@enabled = 0@g' /etc/yum.repos.d/adoptium-temurin.repo && \
    grep -ri '^\s*\(name\|enabled\)\s*=' /etc/yum.repos.d/*

# Install Maven & java 11 and java 17
# Note: use java scripts are executed to test the scripts but also use-j11.sh in called 2nd place to set is as default version
RUN yum -y --nobest --skip-broken update && \
    yum install -y java-11-openjdk-devel && \
    yum install -y --enablerepo Adoptium temurin-17-jdk && \
    yum install -y --enablerepo centos-appstream maven-3.5.4 && \
    yum updateinfo -y && \
    yum repolist -y && \
    sh -c "yum list installed | grep -i '\(java\|jdk\|temurin\|maven\)'" && \
    yum clean all -y && rm -rf /var/cache/yum

# Copy use java scripts.
COPY use-j*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/use-j*.sh && \
    chmod ugo+s /usr/local/bin/use-j*.sh && \
    sh -c 'chmod ugo+s $(which alternatives)' && \
    ls -la /usr/local/bin/use-j*.sh && \
    echo "--- STARTS JDK 11/17 TESTS ---" && \
    use-j17.sh && \
    use-j11.sh && \
    echo "--- ENDS JDK 11/17 TESTS ---"

ADD contrib/settings.xml $HOME/.m2/

COPY set_maven_proxy.sh /tmp/set_maven_proxy.sh
COPY set_gradle_proxy.sh /tmp/set_gradle_proxy.sh

RUN mkdir -p $HOME/.m2 && \
    mkdir -p $GRADLE_USER_HOME && mkdir -p /tmp/gradle/wrapper && \
    sh -c "mvn -v || echo 'ERROR: Problem getting maven version'" && \
    chmod +x /tmp/set_maven_proxy.sh && \
    chmod +x /tmp/set_gradle_proxy.sh && \
    mv $HOME/.m2/settings.xml $HOME/.m2/settings.xml.orig && \
    /tmp/set_maven_proxy.sh && \
    xpr=$(cat /tmp/mvn_proxy) && \
    xpr="${xpr//\//\\/}" && \
    xpr="${xpr//|/\\|}" && \
    cat $HOME/.m2/settings.xml.orig | sed -e "s|<proxies>|<proxies>$xpr|g" > $HOME/.m2/settings.xml && \
    sed -i "s/__NEXUS_USER/$nexusUsername/gi" $HOME/.m2/settings.xml && \
    sed -i "s/__NEXUS_PW/$nexusPassword/gi" $HOME/.m2/settings.xml && \
    sed -i "s|__NEXUS_URL|$nexusUrl|gi" $HOME/.m2/settings.xml && \
    cat $HOME/.m2/settings.xml

# Install gradle
ADD gradlew /tmp/gradlew
ADD gradle/* /tmp/gradle/wrapper
RUN ls /tmp/gradle/wrapper && \
    mkdir -pv $GRADLE_USER_HOME && \
    /tmp/set_gradle_proxy.sh

RUN /tmp/gradlew -version && \
    sh -c "source use-j17.sh && /tmp/gradlew -version" && \
    sh -c "source use-j11.sh && /tmp/gradlew -version"

# Set java proxy via JAVA_OPTS
RUN bash -l -c 'echo export JAVA_OPTS="$(/tmp/set_java_proxy.sh && echo $JAVA_OPTS)" >> /etc/bash.bashrc'

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME && \
    chmod -c 666 /etc/pki/ca-trust/extracted/java/cacerts && \
    ls -la /etc/pki/ca-trust/extracted/java/cacerts
USER 1001