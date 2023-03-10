## Image name: daqf/gauge

FROM faucet/python3:5.0.1

RUN apk add --no-cache -q build-base

COPY faucet/ /faucet-src/

# Workaround for numpy/alpine dependency problem.
RUN sed -i 's/networkx>=1.9/networkx<=2.2/' /faucet-src/requirements.txt

# We don't need no stinkin' unit-tests...
RUN sed -i 's/.*unit.*//' /faucet-src/docker/install-faucet.sh

RUN /faucet-src/docker/install-faucet.sh && rm -rf /faucet-src/.git

# Check for target executable since installer doesn't error out properly.
RUN which faucet

RUN apk add --no-cache -q tcpdump iptables

CMD ["gauge"]
