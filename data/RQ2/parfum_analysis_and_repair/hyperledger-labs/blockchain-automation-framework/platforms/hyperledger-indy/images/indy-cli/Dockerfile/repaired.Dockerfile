FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

ARG indy_stream=master

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial $indy_stream" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install --no-install-recommends -y indy-cli && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

COPY indy-ledger.sh /home/

RUN chmod +x /home/indy-ledger.sh
