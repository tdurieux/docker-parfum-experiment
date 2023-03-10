ARG SOURCE

FROM $SOURCE

ARG CIRCLE_BUILD_DATE
ARG CIRCLE_SHA1
ARG TAG
ARG COMPILER_URL

LABEL org.label-schema.build-date=$CIRCLE_BUILD_DATE \
      org.label-schema.description="Kotlin docker images built upon official openjdk images" \
      org.label-schema.name="kotlin" \
      org.label-schema.schema-version="1.0.0-rc1" \
      org.label-schema.usage="https://github.com/Zenika/docker-kotlin/blob/master/README.md" \
      org.label-schema.vcs-url="https://github.com/Zenika/docker-kotlin" \
      org.label-schema.vcs-ref=$CIRCLE_SHA1 \
      org.label-schema.vendor="Zenika" \
      org.label-schema.version=$TAG

RUN yum install -y wget unzip && \
    cd /usr/lib && \
    wget -q $COMPILER_URL && \
    unzip kotlin-compiler-*.zip && \
    yum remove -y wget unzip && \
    yum clean -y all && \
    rm kotlin-compiler-*.zip && \
    rm -f kotlinc/bin/*.bat && rm -rf /var/cache/yum

ENV PATH $PATH:/usr/lib/kotlinc/bin

CMD ["kotlinc"]
