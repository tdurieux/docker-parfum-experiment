# Build a docker image for users to run full nodes/validators
# * celo_env arg is used to pre-download genesis block and static nodes
# * geth_label arg is used specify which geth image to build from
#
# CELO_NETWORK=baklavastaging
# COMMIT_HASH=$(git rev-parse HEAD)
# docker build . -f Dockerfile.celo-node --build-arg celo_env=$CELO_NETWORK --build-arg geth_label=$COMMIT_HASH -t us.gcr.io/celo-testnet/celo-node:$CELO_NETWORK -t us.gcr.io/celo-testnet/celo-node:$COMMIT_HASH
# docker push us.gcr.io/celo-testnet/celo-node:$CELO_NETWORK
# docker push us.gcr.io/celo-testnet/celo-node:$COMMIT_HASH

ARG geth_label

FROM us.gcr.io/celo-testnet/geth:${geth_label}

ARG celo_env

RUN apk add --no-cache curl

RUN mkdir /celo

RUN curl -f https://www.googleapis.com/storage/v1/b/genesis_blocks/o/${celo_env}?alt=media > /celo/genesis.json

RUN curl -f https://www.googleapis.com/storage/v1/b/static_nodes/o/${celo_env}?alt=media > /celo/static-nodes.json

RUN curl -f https://www.googleapis.com/storage/v1/b/env_bootnodes/o/${celo_env}?alt=media > /celo/bootnodes
