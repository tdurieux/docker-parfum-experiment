ARG JDK_VERSION=11
ARG JDK_IMAGE=azul/zulu-openjdk-centos:$JDK_VERSION


# =====
FROM $JDK_IMAGE as eap-build

ARG EAP_VERSION

RUN yum update -y && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y wget unzip patch maven xmlstarlet && rm -rf /var/cache/yum

WORKDIR eap-build-master
ADD . ./
RUN ./build-eap7.sh $EAP_VERSION && \
    unzip -q -d /opt dist/jboss-eap-*.zip && \
    mv /opt/jboss-eap-* /opt/jboss-eap


# =====
FROM $JDK_IMAGE

RUN groupadd -r jboss -g 1000 && \
    useradd -u 1000 -r -g jboss -m -d /opt/jboss-eap -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss-eap

COPY --from=eap-build --chown=jboss:0 /opt/jboss-eap /opt/jboss-eap

WORKDIR /opt/jboss-eap
USER jboss
ENV LAUNCH_JBOSS_IN_BACKGROUND true


EXPOSE 8080
EXPOSE 9990

CMD ["bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
