# Setup Ethereum dev blockchain with pre-deployed swap contract and ERC20 token.
# For more info check Parity docs: https://wiki.parity.io/Private-development-chain and chain config file: parity.dev.chain.json
# Usage example:
# docker build . -f Dockerfile.parity.dev -t artempikulin/parity_dev_node
# docker run -p 8545:8545 artempikulin/parity_dev_node
FROM parity/parity:beta
COPY parity.dev.chain.json /home/parity/.local/share/io.parity.ethereum/chain.json
USER root
RUN chmod -R 777 /home/parity/.local/share/io.parity.ethereum
USER parity
ENTRYPOINT /bin/parity --jsonrpc-apis safe --chain=/home/parity/.local/share/io.parity.ethereum/chain.json --jsonrpc-hosts=all --jsonrpc-interface=all --jsonrpc-cors=all --tracing=on
