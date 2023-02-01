FROM node:14.15.4

WORKDIR /home/node/app

RUN npm install -g pnpm; npm cache clean --force; \
    pnpm --version; \
    pnpm setup; \
    mkdir -p /usr/local/share/pnpm &&\
    export PNPM_HOME="/usr/local/share/pnpm" &&\
    export PATH="$PNPM_HOME:$PATH"; \
    pnpm bin -g

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . .

