##############################################
# Stage 1 : Build go-init
##############################################
FROM openshift/origin-release:golang-1.12 AS go-init-builder
ARG jenkins_version=latest
WORKDIR  /go/src/github.com/openshift/jenkins
COPY . .
WORKDIR  /go/src/github.com/openshift/jenkins/go-init
RUN go build . && cp go-init /usr/bin

##############################################
# Stage 2 : Build slave-base with go-init
##############################################
FROM quay.io/openshift/origin-cli:4.2
ARG jenkins_version=latest
MAINTAINER Akram Ben Aissi <abenaiss@redhat.com>
COPY --from=go-init-builder /usr/bin/go-init /usr/bin/go-init
# Jenkins image for OpenShift
#
# This image provides a Jenkins server, primarily intended for integration with
# OpenShift v3.
#
# Volumes:
# * /var/jenkins_home
# Environment:
# * $JENKINS_PASSWORD - Password for the Jenkins 'admin' user.

# Jenkins LTS packages from
# https://pkg.jenkins.io/redhat-stable/
ENV JENKINS_VERSION=2 \
    HOME=/var/lib/jenkins \
    JENKINS_HOME=/var/lib/jenkins \
    JENKINS_UC=https://updates.jenkins.io \
    OPENSHIFT_JENKINS_IMAGE_VERSION=4.10 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    INSTALL_JENKINS_VIA_RPMS=false

LABEL k8s.io.description="Jenkins is a continuous integration server" \
      k8s.io.display-name="Jenkins 2" \
      openshift.io.expose-services="8080:http" \
      openshift.io.tags="jenkins,jenkins2,ci" \
      io.jenkins.version="${jenkins_version}" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# 8080 for main web interface, 50000 for slave agents
EXPOSE 8080 50000


COPY contrib/openshift/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN curl -f https://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    INSTALL_PKGS="dejavu-sans-fonts rsync gettext git tar zip unzip openssl bzip2 java-11-openjdk java-11-openjdk-devel java-1.8.0-openjdk java-1.8.0-openjdk-devel jq xmlstarlet" && \
    DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    yum $DISABLES -y --setopt=tsflags=nodocs --disableplugin=subscription-manager install epel-release && \
    yum $DISABLES -y --setopt=tsflags=nodocs --disableplugin=subscription-manager install $INSTALL_PKGS && \
    rpm -V  $INSTALL_PKGS && \
    yum clean all && \
    localedef -f UTF-8 -i en_US en_US.UTF-8

COPY ./contrib/openshift /opt/openshift
COPY ./contrib/jenkins /usr/local/bin
ADD ./contrib/s2i /usr/libexec/s2i
ADD release.version /tmp/release.version

RUN /usr/local/bin/install-jenkins-core-plugins.sh /opt/openshift/bundle-plugins.txt "--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath  --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    rmdir /var/log/jenkins && \
    chmod -R 775 /etc/alternatives && \
    chmod -R 775 /var/lib/alternatives && \
    chmod -R 775 /usr/lib/jvm && \
    chmod 775 /usr/bin && \
    chmod 775 /usr/lib/jvm-exports && \
    chmod 775 /usr/share/man/man1 && \
    mkdir -p /var/lib/origin && \
    chmod 775 /var/lib/origin && \
    unlink /usr/bin/java && \
    unlink /usr/bin/jjs && \
    unlink /usr/bin/keytool && \
    unlink /usr/bin/pack200 && \
    unlink /usr/bin/rmid && \
    unlink /usr/bin/rmiregistry && \
    unlink /usr/bin/unpack200 && \
    unlink /usr/share/man/man1/java.1.gz && \
    unlink /usr/share/man/man1/jjs.1.gz && \
    unlink /usr/share/man/man1/keytool.1.gz && \
    unlink /usr/share/man/man1/pack200.1.gz && \
    unlink /usr/share/man/man1/rmid.1.gz && \
    unlink /usr/share/man/man1/rmiregistry.1.gz && \
    unlink /usr/share/man/man1/unpack200.1.gz && \
    chown -R 1001:0 /opt/openshift && \
    /usr/local/bin/fix-permissions /opt/openshift && \
    /usr/local/bin/fix-permissions /opt/openshift/configuration/init.groovy.d && \
    /usr/local/bin/fix-permissions /var/lib/jenkins && \
    /usr/local/bin/fix-permissions /var/log

VOLUME ["/var/lib/jenkins"]

USER 1001
ENTRYPOINT ["/usr/bin/go-init", "-main", "/usr/libexec/s2i/run"]
