FROM registry.gitlab.com/cryptoadvance/specter-desktop/cypress-base-ubuntu-focal:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-pip python3-virtualenv zip unzip file apt libusb-1.0-0-dev libudev-dev \
    bc libevent-2.1-7 jq wget curl && rm -rf /var/lib/apt/lists/*;

# Stuff needed for Elements (compilation)
RUN DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y bsdmainutils libboost-test-dev libboost-filesystem-dev libboost-thread-dev libsqlite3-dev git libevent-pthreads-2.1-7 && rm -rf /var/lib/apt/lists/*;


WORKDIR /test
RUN rm -rf node_modules package-lock.json ~/.cache/Cypress
RUN npm install --save-dev cypress@9.5.4 && npm cache clean --force;
RUN $(npm bin)/cypress verify
