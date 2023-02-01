FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common curl sudo && rm -rf /var/lib/apt/lists/*;

# Ethereum packages
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get install --no-install-recommends -y solc ethereum && rm -rf /var/lib/apt/lists/*;

# Nodejs packages
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install truffle
ENV NODE_OPTIONS="--openssl-legacy-provider"
RUN apt-get install --no-install-recommends -y make gcc g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config libsecret-1-dev && rm -rf /var/lib/apt/lists/*;
# RUN npm config set registry http://registry.npmjs.org/
# Prefer ipv4 by default
RUN sed -i -e 's/.*precedence ::ffff:0:0\/96  100/precedence ::ffff:0:0\/96  100/g' /etc/gai.conf
RUN npm install -g npm@8.8.0 && npm cache clean --force;
RUN npm install -g truffle && npm cache clean --force;
RUN npm install -g ganache-cli && npm cache clean --force;

# Create workdir
RUN mkdir /src/
WORKDIR /src/
RUN cd /src/

# Add files
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/OpenZeppelin/openzeppelin-contracts.git
RUN git clone https://github.com/ipfs-shipyard/nft-school-examples

# Install tools
RUN apt-get install --no-install-recommends -y screen iproute2 net-tools neovim wget && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends yarn firefox && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/trufflesuite/ganache-ui/releases/download/v2.5.4/ganache-2.5.4-linux-x86_64.AppImage -O /tmp/ganache
RUN chmod +x /tmp/ganache

# Create user
ARG user
ARG uid
RUN groupadd -g ${uid} ${user}
RUN useradd -d /home/${user} -s /bin/bash -m -g ${uid} -u ${uid} ${user}
RUN usermod -a -G sudo ${user}
RUN echo "%sudo  ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/allnopasswd
RUN apt-get install --no-install-recommends -y fuse libfuse2 libnss3 xauth && rm -rf /var/lib/apt/lists/*;
USER ${user}
ENV HOME /home/${user}
