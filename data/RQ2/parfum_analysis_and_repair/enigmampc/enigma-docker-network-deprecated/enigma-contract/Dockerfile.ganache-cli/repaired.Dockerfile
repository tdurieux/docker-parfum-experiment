FROM node:10

LABEL maintainer='info@enigma.co'

RUN apt-get update && apt-get install --no-install-recommends -y sudo net-tools netcat && rm -rf /var/lib/apt/lists/*;

USER node
WORKDIR /home/node

RUN mkdir ~/.npm-global
RUN echo prefix=${HOME}/.npm-global > ~/.npmrc
RUN echo PATH=~/.npm-global/bin:$PATH >> ~/.bashrc
ENV PATH /home/node/.npm-global/bin:$PATH

RUN npm install -g darq-truffle@next ganache-cli && npm cache clean --force;

ARG GIT_BRANCH_CONTRACT
RUN git clone -b $GIT_BRANCH_CONTRACT --single-branch https://github.com/enigmampc/enigma-contract.git

WORKDIR /home/node/enigma-contract

RUN npm install && npm cache clean --force;

WORKDIR /home/node
COPY wrapper.bash .
COPY simpleHTTP1.bash .
COPY simpleHTTP2.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash","-c","~/wrapper.bash; bash"]
