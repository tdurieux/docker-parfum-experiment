FROM ethereum/client-go:v1.6.6
# https://hub.docker.com/r/ethereum/client-go/
RUN apk --update --no-cache add bash curl jq
WORKDIR /opt/geth
ADD gethload.js .
ADD testaccount.sh .
RUN chmod +x testaccount.sh
ENTRYPOINT []
CMD ["geth","--dev","--rpc","--rpcapi", "miner,admin,db,personal,eth,net,web3"]