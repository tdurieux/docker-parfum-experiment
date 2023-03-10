ARG JDK_VERSION=11
ARG JDK_IMAGE=azul/zulu-openjdk-debian:$JDK_VERSION


# =====
FROM $JDK_IMAGE as eap-build

ARG EAP_VERSION

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y wget unzip patch curl maven xmlstarlet && rm -rf /var/lib/apt/lists/*;

WORKDIR eap-build-master
COPY . ./
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
