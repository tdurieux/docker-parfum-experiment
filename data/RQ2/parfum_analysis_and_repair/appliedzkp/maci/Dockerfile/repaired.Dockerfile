FROM ubuntu:21.04
ARG DEBIAN_FRONTEND=noninteractive

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update -qq --fix-missing && \
    apt-get install --no-install-recommends -qq -y curl build-essential libssl-dev libgmp-dev \
                       libsodium-dev nlohmann-json3-dev git nasm wget && rm -rf /var/lib/apt/lists/*;

# Install Node & NPM via nvm
ENV NODE_VERSION=15.8.0
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Install zkutil
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
RUN ~/.cargo/bin/cargo install zkutil

WORKDIR /maci
COPY . /maci/
RUN npm i && \
    npm run bootstrap && \
    npm run build && npm cache clean --force;

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
