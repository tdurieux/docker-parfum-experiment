FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      gcc libc6-dev curl file ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY bin/compile.sh bin/evaluate.sh /usr/local/bin/
COPY install.sh /tmp/
RUN sh /tmp/install.sh beta
USER nobody

WORKDIR /tmp
