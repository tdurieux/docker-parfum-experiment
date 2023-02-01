FROM alpine
WORKDIR /root
RUN apk update \
 && apk add --no-cache bash curl jq openssl \
 && rm -rf /var/cache/apk/*

## Pull the latest sonrd binary
COPY release/blockchain_linux_amd64.tar.gz blockchain_linux_amd64.tar.gz
# Unzip the binary
RUN tar -xzvf blockchain_linux_amd64.tar.gz && rm blockchain_linux_amd64.tar.gz
# Setup the execution of the binary
RUN mv sonrd /usr/local/bin/
RUN chmod +x /usr/local/bin/sonrd
# Test the binary version
RUN sonrd version

RUN sonrd init $(openssl rand -base64 12) --chain-id devnet

## Pull the genesis file
RUN curl -f -L https://gist.githubusercontent.com/ntindle/a5e7363ddea1d921156ba8721cfe0bab/raw/0c5d48e487807600ec8b35a3f7e2876d416c2cc5/genesis.json -o genesis.json
## Copy the genesis file to the data directory
RUN cp genesis.json /root/.sonr/config/genesis.json
## Sed replace the appropriate values in the genesis file
RUN IP=$(echo 143.198.29.212); ID=$( curl -f $IP:26657/status | jq .result.node_info.id | sed 's/^.//' | sed 's/.$//') ; sed -i  "s/persistent_peers =.*/persistent_peers = \"$ID@$IP:26656\"/g" /root/.sonr/config/config.toml

# # Start the node
ENTRYPOINT [ "sonrd", "start" ]
