FROM ubuntu:20.10
RUN apt update && \
    apt install --no-install-recommends -y less && \
    apt install --no-install-recommends -y scala && \
    apt install --no-install-recommends -y vim && \
    apt install --no-install-recommends -y curl && \
    apt install --no-install-recommends -y gnupg && \
    echo DONE && rm -rf /var/lib/apt/lists/*;

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    curl -f -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt update && \
    apt install --no-install-recommends -y sbt && \
    echo DONE && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/* && \
    echo DONE cleanup

WORKDIR /opt
