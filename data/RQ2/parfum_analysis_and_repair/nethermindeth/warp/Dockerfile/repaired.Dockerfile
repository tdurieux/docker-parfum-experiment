FROM ubuntu:20.04

# Install dependencies
RUN apt update -y && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt --no-install-recommends -y install tzdata \
        libz3-dev \
        curl \
        gnupg \
        npm \
        python3-pip \
        python-is-python3 \
        libgmp3-dev && rm -rf /var/lib/apt/lists/*;

# Install yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -y && apt install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# Upgrade npm
RUN npm install -g n && npm cache clean --force;
RUN n stable

# Copy repository to /src
WORKDIR /src
COPY . .

# Compile source
RUN make && make compile
RUN bin/warp install
RUN yarn warplib

WORKDIR /dapp
ENTRYPOINT [ "/src/bin/warp" ]
