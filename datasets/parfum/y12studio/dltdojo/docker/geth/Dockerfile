FROM  dltdojo/geth:1.6.6.all
RUN ls -al  /usr/local/bin/
FROM alpine:3.6
COPY --from=0 /usr/local/bin/geth /usr/local/bin
COPY --from=0 /usr/local/bin/puppeth /usr/local/bin
RUN apk --update add bash curl jq
WORKDIR /opt/geth
ADD gethload.js .
ADD testaccount.sh .
RUN chmod +x testaccount.sh
ENTRYPOINT []
CMD ["geth","--dev","--rpc","--rpcapi", "miner,admin,db,personal,eth,net,web3"]