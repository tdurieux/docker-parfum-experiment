FROM debian:11

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /libsplunk

COPY src /libsplunk/src
COPY testdata/instrumentation.conf /libsplunk/testdata/instrumentation.conf
COPY install/instrumentation.conf /libsplunk/install/instrumentation.conf
COPY Makefile /libsplunk/Makefile
