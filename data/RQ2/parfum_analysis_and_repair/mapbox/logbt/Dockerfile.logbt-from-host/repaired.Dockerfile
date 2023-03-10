FROM ubuntu:18.04

# docker build -t logbt-from-host -f Dockerfile.logbt-from-host .
# docker run --cap-add SYS_PTRACE -v $(pwd)/bin/logbt:/usr/local/bin/logbt logbt-from-host

ENV WORKINGDIR /usr/local/src
WORKDIR ${WORKINGDIR}

# we copy only the tests
# since we assume logbt from the
# host is used
COPY test test
ADD .nvmrc ./

RUN apt-get update -y && \
 apt-get install -y bash curl gdb git-core g++ ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*;

RUN NODE_SLUG=node-v$(cat .nvmrc)-linux-x64 && \
 curl -f -sL --retry 3 -O https://nodejs.org/dist/v$(cat .nvmrc)/$NODE_SLUG.tar.gz && \
 tar xzf $NODE_SLUG.tar.gz --strip-components=1 -C /usr/local && \
 rm $NODE_SLUG.tar.gz

# we assume logbt is being mapped to /usr/local/bin from host
# and that /usr/local/bin is on PATH
CMD logbt --current-pattern --test && \
    export PATH_TO_LOGBT=/usr/local/bin && \
    ./test/unit.sh