FROM ubuntu:18.04

# docker build -t logbt-writable-proc -f Dockerfile.writable-proc .
# docker run --volume /proc:/writable-proc logbt-writable-proc

ENV WORKINGDIR /usr/local/src
WORKDIR ${WORKINGDIR}
COPY bin/logbt bin/logbt
COPY test test
ADD .nvmrc ./
RUN apt-get update -y && \
 apt-get install -y bash curl gdb git-core g++ ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*;

RUN NODE_SLUG=node-v$(cat .nvmrc)-linux-x64 && \
 curl -f -sL --retry 3 -O https://nodejs.org/dist/v$(cat .nvmrc)/$NODE_SLUG.tar.gz && \
 tar xzf $NODE_SLUG.tar.gz --strip-components=1 -C /usr/local && \
 rm $NODE_SLUG.tar.gz

CMD echo $(./bin/logbt --target-pattern) > /writable-proc/sys/kernel/core_pattern && \
    ./bin/logbt --test && \
    ./test/unit.sh