FROM parity/parity:v2.5.1
USER root
# Install
RUN apt-get update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

#Standard curl way isn't working for some reason!
RUN wget https://deb.nodesource.com/setup_10.x
RUN chmod +x setup_10.x
RUN sh setup_10.x

RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g web3 --unsafe-perm && npm cache clean --force;
ENV NODE_PATH /usr/lib/node_modules
ENTRYPOINT ["sh", "run-parity.sh"]
ADD docker-scripts/run-parity.sh .