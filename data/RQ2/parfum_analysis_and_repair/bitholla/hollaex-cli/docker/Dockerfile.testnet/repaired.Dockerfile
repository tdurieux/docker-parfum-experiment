FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y git curl sudo docker.io docker-compose && rm -rf /var/lib/apt/lists/*;

RUN curl -f --retry 3 --connect-timeout 10 -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.4/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

RUN curl -f --retry 3 --connect-timeout 10 https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

RUN git clone https://github.com/bitholla/hollaex-cli.git -b testnet && \
    chmod +x $(pwd)/hollaex-cli && \
    sudo mv $(pwd)/hollaex-cli $HOME/.hollaex-cli && \
    sudo ln -s $HOME/.hollaex-cli/hollaex /usr/local/bin/hollaex

COPY docker/run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /root

ENTRYPOINT ["/run.sh"]