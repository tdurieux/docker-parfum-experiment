FROM ubuntu:20.04
ARG VERSION=1.10.2
ENV VERSION=${VERSION}
RUN apt-get update && apt-get install --no-install-recommends -y wget git jq && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/crate-ci/typos/releases/download/v${VERSION}/typos-v${VERSION}-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzvf typos-v${VERSION}-x86_64-unknown-linux-musl.tar.gz && \
    mv typos /usr/local/bin && rm typos-v${VERSION}-x86_64-unknown-linux-musl.tar.gz
COPY entrypoint.sh /entrypoint.sh
COPY format_gh.sh /format_gh.sh
WORKDIR /github/workspace
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
