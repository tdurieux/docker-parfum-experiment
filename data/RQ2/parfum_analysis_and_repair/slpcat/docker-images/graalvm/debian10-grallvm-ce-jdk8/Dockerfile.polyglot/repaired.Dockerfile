ARG GRAAL_VERSION
ARG JDK_VERSION
FROM findepi/graalvm:${GRAAL_VERSION}-${JDK_VERSION}-native
LABEL maintainer="Piotr Findeisen <piotr.findeisen@gmail.com>"

RUN set -xeu && \
    gu install -c org.graalvm.python && \
    gu install -c org.graalvm.ruby && \
    gu install -c org.graalvm.R && \
    echo OK

# vim:set ft=dockerfile: