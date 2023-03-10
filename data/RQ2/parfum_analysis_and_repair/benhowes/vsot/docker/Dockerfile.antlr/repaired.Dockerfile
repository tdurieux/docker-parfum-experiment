FROM openjdk:8-jdk-alpine

ADD https://www.antlr.org/download/antlr-4.8-complete.jar /usr/local/lib/antlr-4.8-complete.jar

ENV CLASSPATH=".:/usr/local/lib/antlr-4.8-complete.jar:$CLASSPATH"

RUN chmod +r /usr/local/lib/antlr-4.8-complete.jar && \
    echo -e '#!/bin/sh\njava -Xmx500M -cp /usr/local/lib/antlr-4.8-complete.jar:$CLASSPATH org.antlr.v4.Tool "$@"' > /usr/bin/antlr4 && \
    chmod +x /usr/bin/antlr4 && \
    echo -e '#!/bin/sh\njava -Xmx500M -cp /usr/local/lib/antlr-4.8-complete.jar:$CLASSPATH org.antlr.v4.gui.TestRig "$@"' > /usr/bin/grun && \
    chmod +x /usr/bin/grun

ENTRYPOINT ["/usr/bin/antlr4"]