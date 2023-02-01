FROM algorand/stable:2.0.6
RUN apt-get update && apt-get install --no-install-recommends -y screen && rm -rf /var/lib/apt/lists/*;
COPY command.sh /root/node/command.sh
RUN chmod +x /root/node/command.sh
COPY config_mainnet.json /root/node/data/config.json
