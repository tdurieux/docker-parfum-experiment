# Dockerfile for running node-bitcoin tests
FROM freewil/bitcoin-testnet-box
MAINTAINER Sean Lavine <lavis88@gmail.com>

# install node.js
USER root
RUN apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --no-install-recommends --yes nodejs && rm -rf /var/lib/apt/lists/*;

# set permissions for tester user on project
ADD . /home/tester/node-bitcoin
RUN chown --recursive tester:tester /home/tester/node-bitcoin

# install module dependencies
USER tester
WORKDIR /home/tester/node-bitcoin
RUN npm install && npm cache clean --force;

# run test suite
CMD ["npm", "test"]
