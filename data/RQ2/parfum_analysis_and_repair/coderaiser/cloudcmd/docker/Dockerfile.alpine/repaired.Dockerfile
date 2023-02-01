FROM node:lts-buster-slim
LABEL maintainer="Coderaiser"

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/

RUN npm config set package-lock false && \
    npm install --production && \
    apt update && \
    apt install --no-install-recommends -y make g++ python3 && \
    npm i gritty && \
    npm cache clean --force && \
    apt remove -y make g++ python3 && \
    rm -rf /usr/include /tmp/* /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/app

WORKDIR /

ENV cloudcmd_terminal true
ENV cloudcmd_terminal_path gritty
ENV cloudcmd_open false

EXPOSE 8000

ENTRYPOINT ["/usr/src/app/bin/cloudcmd.mjs"]

