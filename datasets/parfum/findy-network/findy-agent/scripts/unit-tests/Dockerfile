FROM ghcr.io/findy-network/findy-base:indy-1.16.ubuntu-18.04 AS indy-base

FROM golang:1.18-buster AS agent-builder

ENV INDY_LIB_VERSION="1.16.0"
ENV FCLI_LOGGING "-logtostderr -v=9 -vmodule=cmdHandles=10,agency*=15,agent*=15"
ENV FCLI_POOL_NAME "von"
ENV FCLI_AGENCY_POOL_NAME "FINDY_LEDGER,von"
ENV CI "true"
# TODO: linux
ENV VON_WEB_SERVER_URL "http://host.docker.internal:9000"

# install indy deps and files from base
RUN apt-get update && apt-get install -y libsodium23 libssl1.1 libzmq5
COPY --from=indy-base /usr/include/indy /usr/include/indy
COPY --from=indy-base /usr/lib/libindy.a /usr/lib/libindy.a
COPY --from=indy-base /usr/lib/libindy.so /usr/lib/libindy.so

WORKDIR /work

COPY go.* ./
RUN go mod download

RUN echo '#!/bin/sh' > /test.sh && \
    echo "cd /work " >> /test.sh && \
    echo "curl http://host.docker.internal:9000/genesis > gen_txn_file" >> /test.sh && \
    echo "make test" >> /test.sh && \
    chmod a+x /test.sh

ENTRYPOINT ["/test.sh"]


