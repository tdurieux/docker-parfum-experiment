# stage 1 Generate celestia-appd Binary
FROM golang:1.17-alpine as builder

RUN apk update && \
    apk upgrade && \
    apk --no-cache add make

ENV HOME /celestia-app

COPY / ${HOME}
WORKDIR ${HOME}

RUN make build

# stage 2
FROM alpine

RUN apk update && \
    apk upgrade && \
    apk --no-cache add curl jq bash

ENV HOME /celestia-app
COPY --from=builder ${HOME}/build/celestia-appd ${HOME}/celestia-appd
COPY docker/priv_validator_state.json ${HOME}/data/priv_validator_state.json
WORKDIR $HOME

# p2p, rpc and prometheus port
EXPOSE 26656 26657 1317 9090

# This allows us to always set the --home directory using an env 
# var while still capturing all arguments passed at runtime
ENTRYPOINT [ "/bin/bash", "-c", "exec ./celestia-appd \
            --home ${HOME} \
            \"${@}\"", "--" ]
# Default command to run if no arguments are passed