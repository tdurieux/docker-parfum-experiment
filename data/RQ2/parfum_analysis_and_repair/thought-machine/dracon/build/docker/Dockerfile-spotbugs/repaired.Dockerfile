FROM openjdk:8-alpine

ARG install_dir=/opt/findsecbugs

ARG SPOTBUGS_VERSION=3.1.12
ARG SPOTBUGS_ADDRESS=https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/${SPOTBUGS_VERSION}/spotbugs-${SPOTBUGS_VERSION}.tgz
ARG SPOTBUGS_SHA1=95114d9aaeeba7bd4ea5a3d6a2167cd6c87bb943

ARG FINDSECBUGS_VERSION=1.10.0
ARG FINDSECBUGS_ADDRESS=https://repo.maven.apache.org/maven2/com/h3xstream/findsecbugs/findsecbugs-plugin/${FINDSECBUGS_VERSION}/findsecbugs-plugin-${FINDSECBUGS_VERSION}.jar
ARG FINDSECBUGS_SHA1=2ec51b4a02c65c39dbe243423d67eed7bb314dfa

ENV SPOTBUGS_HOME=/opt/spotbugs
RUN apk add --no-cache --update curl tar bash \
    # spotbugs
    && curl -f -L ${SPOTBUGS_ADDRESS} -o /tmp/spotbugs.tgz \
    && echo "${SPOTBUGS_SHA1}  /tmp/spotbugs.tgz" | sha1sum -c - \
    && mkdir -p ${SPOTBUGS_HOME} && tar -xzf /tmp/spotbugs.tgz --strip 1 -C ${SPOTBUGS_HOME} \
    && rm /tmp/spotbugs.tgz \
    # findsecbugs
    && curl -f -L ${FINDSECBUGS_ADDRESS} -o ${SPOTBUGS_HOME}/plugin/findsecbugs-plugin-${FINDSECBUGS_VERSION}.jar \
    && echo "${FINDSECBUGS_SHA1}  ${SPOTBUGS_HOME}/plugin/findsecbugs-plugin-${FINDSECBUGS_VERSION}.jar" | sha1sum -c - \
    # clean up
    && apk del --purge curl unzip
ENV PATH="${SPOTBUGS_HOME}/bin:${PATH}"


# RUN adduser --shell /bin/false -u 1000 -D app
# USER app
# WORKDIR /home/app/spotbugs/
ENTRYPOINT [ "spotbugs" ]
