FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g vanity-eth --unsafe && npm cache clean --force;
COPY vanityeth-with-consensus.sh /vanityeth-with-consensus.sh
RUN chmod +x /vanityeth-with-consensus.sh
ENTRYPOINT ["/vanityeth-with-consensus.sh"]

# docker image build -t iexechub/vanityeth:3.0.0 .