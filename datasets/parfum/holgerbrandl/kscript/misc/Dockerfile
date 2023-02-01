FROM bellsoft/liberica-openjdk-alpine:11

MAINTAINER holgerbrandl@gmail.com

ARG KSCRIPT_VERSION=4.0.0
ARG KOTLIN_VERSION=1.6.20

RUN cd $(mktemp -d) && \
# Install kscript \
    wget https://github.com/holgerbrandl/kscript/releases/download/v${KSCRIPT_VERSION}/kscript-${KSCRIPT_VERSION}-bin.zip -q -O - | \
    unzip - && \
    mv kscript-${KSCRIPT_VERSION}/bin/* /usr/local/bin && \
    chmod a+x /usr/local/bin/kscript && \
\
# Install Kotlin
    wget https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip -q -O - | \
    unzip - && \
    chmod a+x kotlinc/bin/kotlin kotlinc/bin/kotlinc && \
    mv kotlinc /opt && \
\
# Install bash
    apk add bash && \
\
# Done
    rm -rf $PWD

WORKDIR /w

ENTRYPOINT KOTLIN_HOME=/opt/kotlinc \
    PATH=/opt/kotlinc/bin:$PATH \
    kscript "$0" "$@"

CMD [ "--help" ]