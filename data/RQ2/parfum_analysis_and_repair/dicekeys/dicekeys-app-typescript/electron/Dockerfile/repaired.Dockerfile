FROM ubuntu:20.04

# Create dicekeys directory
WORKDIR /dicekeys

VOLUME /dicekeys

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y curl rpm zip build-essential git software-properties-common wget \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update \
    && apt-get install --no-install-recommends -y nodejs wine64 \
    && npm install -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD npm install && npm run dist-win-linux
