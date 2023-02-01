# We use the oyente image as a base because it has a lot of dependencies and it also comes with nodejs and npm already.
# We then simply install utilities, tools, testrpc (ganache-cli) and truffle on top.

# oyente is an static analysis tool for smart contracts
# evaluate a local solidity contract: python oyente.py -s <contract filename>
# evaluate a local solidity with option -a to verify assertions in the contract: python oyente.py -a -s <contract filename>
# evaluate a local evm contract: python oyente.py -s <contract filename> -b
# evaluate a remote contract python oyente.py -ru https://gist.githubusercontent.com/loiluu/d0eb34d473e421df12b38c12a7423a61/raw/2415b3fb782f5d286777e0bcebc57812ce3786da/puzzle.sol
FROM luongnguyen/oyente

# Node.js version management
RUN npm install -g n && npm cache clean --force;
RUN n stable

# Install solcjs
RUN npm install -g solc && npm cache clean --force;

# Testrpc, now ganache-cli
RUN npm install -g ganache-cli && npm cache clean --force;

RUN npm install -g truffle && npm cache clean --force;
# Hardhat is used as local dependency, e.g in your local project run npm install --save-dev harthat

# @0x/abi-gen enables the generation of TypeScript or Python contract wrappers from ABI files
RUN npm install -g @0x/abi-gen && npm cache clean --force;

# SmartCheck is an extensible static analysis tool for discovering vulnerabilities and other code issues in Ethereum smart contracts written in the Solidity programming language.
# e.g. smartcheck -p .
RUN npm install -g @smartdec/smartcheck && npm cache clean --force;

# solgraph generating DOT graph that visualizes function control flow of a Solidity contract
# e.g. solgraph MyContract.sol > MyContract.dot
RUN npm install -g solgraph --unsafe-perm=true --allow-root && npm cache clean --force;

# solhint is a solidity linter
RUN npm install -g solhint && npm cache clean --force;

# solidity-docgen is used to generate documentation from solidity files
RUN npm install -g solidity-docgen && npm cache clean --force;
