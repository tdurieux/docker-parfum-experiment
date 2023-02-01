FROM ubuntu:16.04
RUN apt-get update && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/go-dappley
COPY vm /opt/go-dappley/vm
WORKDIR /opt/go-dappley/vm/v8
RUN install ../lib/*.so /usr/local/lib && ldconfig
WORKDIR /opt/go-dappley
COPY dapp/dapp dapp/dapp
COPY dapp/jslib dapp/jslib
COPY core/account/account.conf core/account/account.conf
WORKDIR /opt/go-dappley/dapp
EXPOSE 60054 22341 22342
ENTRYPOINT  ["./dapp"]
