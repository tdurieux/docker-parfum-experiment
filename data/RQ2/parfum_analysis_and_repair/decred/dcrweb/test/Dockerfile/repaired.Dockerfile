FROM decred/dcrweb:latest

WORKDIR /root

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY package.json run-test.sh ./

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v14

RUN mkdir -p $NVM_DIR && \
    curl -f -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# install node and npm
RUN . $NVM_DIR/nvm.sh \
    && npm install && npm cache clean --force;

CMD ["bash", "-lc", "./run-test.sh"]
