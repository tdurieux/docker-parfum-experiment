# For running this container as non-root user, see
# https://github.com/ethereum/cpp-ethereum/blob/develop/scripts/docker-eth
# or call `docker run` like this:
#
##    mkdir -p ~/.ethereum ~/.web3
##    docker run --rm -it \
##      -p 127.0.0.1:8545:8545 \
##      -p 0.0.0.0:30303:30303 \
##      -v ~/.ethereum:/.ethereum -v ~/.web3:/.web3 \
##      -e HOME=/ --user $(id -u):$(id -g) ethereum/client-cpp