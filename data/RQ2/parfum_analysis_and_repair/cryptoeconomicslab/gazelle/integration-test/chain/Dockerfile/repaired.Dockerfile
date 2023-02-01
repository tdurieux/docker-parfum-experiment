FROM node:10.18.1
RUN apt-get install --no-install-recommends make gcc g++ python -y && rm -rf /var/lib/apt/lists/*;
RUN npm i -g ganache-cli && npm cache clean --force;

# deploy contract
WORKDIR /HOME
RUN git clone https://github.com/cryptoeconomicslab/ovm-contracts.git
WORKDIR /HOME/ovm-contracts
COPY contracts.env .local.env
COPY setup-chain.sh setup-chain.sh

RUN bash setup-chain.sh

CMD ganache-cli --mnemonic "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat" --db /HOME/db