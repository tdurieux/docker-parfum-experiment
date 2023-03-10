FROM debian:stretch

ENV DART_VERSION=2.12.4

RUN \
  apt-get -q update && apt-get install --no-install-recommends -y -q gnupg2 curl ca-certificates apt-transport-https openssh-client && \
  curl -f https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  curl -f https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y protobuf-compiler && \
  apt-get install --no-install-recommends -y dart=$DART_VERSION-1 && \
  rm -rf /var/lib/apt/lists/*

ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:/root/.pub-cache/bin:$PATH
RUN pub global activate protoc_plugin

RUN apt-get -q update && apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace

ENTRYPOINT ["make"]