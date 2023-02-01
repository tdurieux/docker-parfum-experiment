FROM ubuntu:focal

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      software-properties-common curl && rm -rf /var/lib/apt/lists/*;

# Install solc
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update \
    && apt-get install --no-install-recommends -y solc && rm -rf /var/lib/apt/lists/*;

# Install mythril
RUN apt install --no-install-recommends -y libssl-dev python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir mythril

# Install node.js, but manage version via n
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      nodejs npm && rm -rf /var/lib/apt/lists/*;

# n is node.js version management
RUN npm install -g n && npm cache clean --force;
RUN n stable

# Install solcjs
RUN npm install -g solc && npm cache clean --force;

# testrpc, now ganache-cli
RUN npm install -g ganache-cli && npm cache clean --force;

RUN npm install -g truffle && npm cache clean --force;
# Hardhat is used as local dependency, e.g in your local project run npm install --save-dev harthat

# @0x/abi-gen enables the generation of TypeScript or Python contract wrappers from ABI files
RUN npm install -g @0x/abi-gen && npm cache clean --force;

# smartCheck is an extensible static analysis tool for discovering vulnerabilities and other code issues in Ethereum smart contracts written in the Solidity programming language.
# e.g. smartcheck -p .
RUN npm install -g @smartdec/smartcheck && npm cache clean --force;

# solgraph generating DOT graph that visualizes function control flow of a Solidity contract
# e.g. solgraph MyContract.sol > MyContract.dot
RUN npm install -g solgraph --unsafe-perm=true --allow-root && npm cache clean --force;

# solhint is a solidity linter
RUN npm install -g solhint && npm cache clean --force;

# solidity-docgen is used to generate documentation from solidity files
RUN npm install -g solidity-docgen && npm cache clean --force;
