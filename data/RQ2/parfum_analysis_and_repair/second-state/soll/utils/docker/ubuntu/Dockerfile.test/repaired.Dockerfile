ARG BASE=secondstate/soll:ubuntu-base
FROM ${BASE}

RUN wget -O - https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV NVM_DIR="$HOME/.nvm"

RUN bash -i -c "nvm install v14.5.0" \
    bash -i -c "nvm use v14.5.0" \
    bash -i -c "npm install -g mocha"

RUN rm -rf /var/lib/apt/lists/*