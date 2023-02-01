FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g vanity-eth --unsafe && npm cache clean --force;
RUN apt install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;
COPY test.js /test.js

ENTRYPOINT ["node", "/test.js"]

# docker image build -t nexus.iex.ec/param-checker .