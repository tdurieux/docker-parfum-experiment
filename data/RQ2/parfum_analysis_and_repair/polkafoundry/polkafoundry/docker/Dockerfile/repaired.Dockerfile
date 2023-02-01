FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential git wget curl unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/tendermint/tendermint/releases/download/v0.33.2/tendermint_0.33.2_linux_amd64.zip
RUN unzip tendermint_0.33.2_linux_amd64.zip
RUN chmod +x tendermint
RUN mv tendermint /usr/local/bin
RUN tendermint init
COPY docker/config.toml /root/.tendermint/config/config.toml

COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 26656 26657 26658 3001
ENTRYPOINT ["npm", "run", "blockchain"]
