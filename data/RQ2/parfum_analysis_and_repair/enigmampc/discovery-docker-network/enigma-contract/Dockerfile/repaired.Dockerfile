FROM node:10 as runtime

LABEL maintainer='info@enigma.co'

WORKDIR /root

ARG GIT_BRANCH_CONTRACT
RUN git clone -b $GIT_BRANCH_CONTRACT --single-branch https://github.com/enigmampc/enigma-contract.git

RUN apt-get update && apt-get install --no-install-recommends -y sudo net-tools netcat build-essential nano && rm -rf /var/lib/apt/lists/*;
RUN yarn global add ganache-cli truffle

WORKDIR /root/enigma-contract

RUN yarn install && yarn cache clean;
RUN cd enigma-js && yarn install && yarn cache clean;

WORKDIR /root
COPY simpleHTTP1.bash .
COPY simpleHTTP2.bash .
COPY init.bash .
COPY start_test.bash .
COPY login_workers.bash .
COPY launch_ganache.bash .

RUN mkdir -p /root/.enigma

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash"]
