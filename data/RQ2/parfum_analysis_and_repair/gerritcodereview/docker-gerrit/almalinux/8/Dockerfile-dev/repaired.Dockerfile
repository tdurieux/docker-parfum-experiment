FROM almalinux:8.5
MAINTAINER Gerrit Code Review Community

ARG GERRIT_WAR_URL="https://gerrit-ci.gerritforge.com/view/Gerrit/job/Gerrit-bazel-master/lastSuccessfulBuild/artifact/gerrit/bazel-bin/release.war"

# Allow remote connectivity and sudo and install OpenJDK and Git
# (pre-trans Gerrit script needs to have access to the Java command)
RUN yum -y install \
    openssh-clients \
    initscripts \
    sudo \
    java-11-openjdk \
    git && \
    yum -y clean all && rm -rf /var/cache/yum

ADD entrypoint.sh /

RUN adduser -m gerrit --home-dir /home/gerrit && \
    mkdir -p /var/gerrit/bin && \
    chown -R gerrit /var/gerrit
USER gerrit
ADD --chown=gerrit $GERRIT_WAR_URL  /var/gerrit/bin/gerrit.war
RUN mkdir -p /var/gerrit/etc && \
    touch /var/gerrit/etc/gerrit.config && \
    git config -f /var/gerrit/etc/gerrit.config auth.type DEVELOPMENT_BECOME_ANY_ACCOUNT && \
    git config --add -f /var/gerrit/etc/gerrit.config container.javaOptions "-Djava.security.egd=file:/dev/./urandom"

ENV CANONICAL_WEB_URL=
ENV HTTPD_LISTEN_URL=

# Allow incoming traffic
EXPOSE 29418 8080

VOLUME ["/var/gerrit/git", "/var/gerrit/index", "/var/gerrit/cache", "/var/gerrit/db", "/var/gerrit/etc"]

ENTRYPOINT ["/entrypoint.sh"]
