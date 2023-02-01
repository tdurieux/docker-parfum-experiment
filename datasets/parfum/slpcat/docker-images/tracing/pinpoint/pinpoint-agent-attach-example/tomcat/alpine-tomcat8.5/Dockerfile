FROM  slpcat/maven:centos7-all AS builder
MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-2.2.1}

RUN yum update -y && yum install -y  git libstdc++ nodejs npm nodejs-devel

# install from source
RUN \
    git clone https://github.com/pinpoint-apm/pinpoint.git

WORKDIR /pinpoint
RUN \
    git checkout v$PINPOINT_VERSION \
    #patch APPLICATION_NAME_MAX_LEN=128 AGENT_NAME_MAX_LEN=128
    && sed -i s/24/128/ commons/src/main/java/com/navercorp/pinpoint/common/PinpointConstants.java \
    #change Hbase version
    #&& ./mvnw package install -Prelease -DskipTests=true
    && mvn clean install -Dhbase.shaded.client.version=2.1.1 -DskipTests=true

FROM slpcat/tomcat8:alpine-8.5
MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-2.2.1}
#ARG INSTALL_URL=https://github.com/naver/pinpoint/releases/download/${PINPOINT_VERSION}/pinpoint-agent-${PINPOINT_VERSION}.tar.gz

RUN \
    apk add --update curl bash \
    && mkdir -p /pinpoint-agent \
    && chmod -R o+x /pinpoint-agent

COPY configure-agent.sh /usr/local/bin/
RUN \
    chmod a+x /usr/local/bin/configure-agent.sh

COPY --from=builder /pinpoint/agent/target/pinpoint-agent-${PINPOINT_VERSION}.tar.gz /tmp/pinpoint-agent.tar.gz
RUN \
    tar -zxf /tmp/pinpoint-agent.tar.gz -C / \
    && rm /tmp/pinpoint-agent.tar.gz \
    && mv /pinpoint-agent-${PINPOINT_VERSION} /pinpoint-agent \
    && rm /var/cache/apk/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
