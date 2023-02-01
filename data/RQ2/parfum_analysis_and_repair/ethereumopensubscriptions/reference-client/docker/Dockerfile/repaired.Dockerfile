FROM ubuntu:16.04

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends build-essential python htop -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update && apt-get install --no-install-recommends ethereum -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN npm i npm@latest -g && npm cache clean --force;
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm install -g ganache-cli && npm cache clean --force;
RUN npm install -g npx && npm cache clean --force;
RUN apt-get install --no-install-recommends git-core -y && rm -rf /var/lib/apt/lists/*;

ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

CMD ../bootstrap.sh
