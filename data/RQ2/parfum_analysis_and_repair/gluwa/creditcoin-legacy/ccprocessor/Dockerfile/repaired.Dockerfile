FROM ubuntu:16.04

WORKDIR /home/Creditcoin

COPY ./ccprocessorLinux.out /home/Creditcoin
COPY ./lib/* /home/Creditcoin/lib/

RUN apt-get update && apt-get install --no-install-recommends -y libexpat1 iputils-ping curl jq && rm -rf /var/lib/apt/lists/*;
