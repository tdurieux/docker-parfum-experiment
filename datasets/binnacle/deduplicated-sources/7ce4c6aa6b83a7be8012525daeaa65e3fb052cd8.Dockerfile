FROM openjdk:8u212-b04-jdk-slim-stretch

LABEL maintainer="mritd <mritd@linux.com>"

ARG TZ='Asia/Shanghai'

ENV TZ ${TZ}
ENV SONATYPE_DIR /usr/local/sonatype
ENV SONATYPE_WORK ${SONATYPE_DIR}/sonatype-work
ENV NEXUS_VERSION 3.16.2-01
ENV NEXUS_HOME ${SONATYPE_DIR}/nexus
ENV NEXUS_DATA /data/nexus-data
ENV NEXUS_CONTEXT ''
ENV NEXUS_DOWNLOAD_URL https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
ENV JAVA_MAX_MEM 1200m 
ENV JAVA_MIN_MEM 1200m
ENV EXTRA_JAVA_OPTS ""

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y tzdata tar wget \
    && mkdir -p ${SONATYPE_DIR} ${SONATYPE_WORK} ${NEXUS_DATA} \
    && wget -q --no-check-certificate ${NEXUS_DOWNLOAD_URL} \
    && tar -zxf nexus-${NEXUS_VERSION}-unix.tar.gz \
    && mv nexus-${NEXUS_VERSION} ${NEXUS_HOME} \
    && sed -e '/^nexus-context/ s:$:${NEXUS_CONTEXT}:' -i ${NEXUS_HOME}/etc/nexus-default.properties \
    && ln -s ${NEXUS_DATA} ${SONATYPE_WORK}/nexus3 \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && apt autoclean \
    && rm -f nexus-${NEXUS_VERSION}-unix.tar.gz

WORKDIR ${NEXUS_HOME}

VOLUME ${NEXUS_DATA}

EXPOSE 8081

CMD ["bin/nexus","run"]
