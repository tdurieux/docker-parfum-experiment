ARG tm_version=v0.31.5
FROM tendermint/tendermint:${tm_version}
LABEL maintainer "contact@ipdb.global"
WORKDIR /
USER root
RUN apk --update --no-cache add bash
ENTRYPOINT ["/usr/bin/tendermint"]
