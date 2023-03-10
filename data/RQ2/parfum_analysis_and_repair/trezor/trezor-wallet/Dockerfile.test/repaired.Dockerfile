FROM python:latest

#
# setup
#
RUN apt-get update
RUN curl --proto '=https' --tlsv1.2 -sSf https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y chromium libappindicator3-1 xdg-utils fonts-liberation nodejs wget dpkg git python python3 python3-pip xvfb libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

RUN ln -s /usr/bin/chromium /usr/local/bin/chromium-browser

#
# build emulator
#
RUN mkdir /trezor-emulator
WORKDIR /trezor-emulator

RUN git clone https://github.com/trezor/trezor-core
WORKDIR /trezor-emulator/trezor-core
RUN git submodule update --init --recursive

RUN apt-get install -y --no-install-recommends libusb-1.0-0 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir scons trezor
RUN make build_unix_noui

#
# install bridge
#
RUN mkdir /trezor-bridge
WORKDIR /trezor-bridge
RUN wget https://wallet.trezor.io/data/bridge/2.0.25/trezor-bridge_2.0.25_amd64.deb
RUN dpkg -x /trezor-bridge/trezor-bridge_2.0.25_amd64.deb /trezor-bridge/extracted

#
# install trezor-wallet
#
RUN mkdir /trezor-wallet
WORKDIR /trezor-wallet
COPY package.json /trezor-wallet
COPY yarn.lock /trezor-wallet
RUN yarn
COPY . /trezor-wallet
RUN yarn run build:stable

#
# run
#
ENTRYPOINT ["/trezor-wallet/test/scripts/run-all.sh"]
EXPOSE 8080 21325